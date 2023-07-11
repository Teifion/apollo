defmodule ApolloWeb.PostLive.FormComponent do
  use ApolloWeb, :live_component

  alias Apollo.Board
  alias Phoenix.PubSub

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.simple_form
        for={@form}
        id="post-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:content]} type="textarea" label="Content" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Post</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{post: post} = assigns, socket) do
    changeset = Board.change_post(post)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"post" => post_params}, socket) do
    changeset =
      socket.assigns.post
      |> Board.change_post(post_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"post" => post_params}, socket) do
    save_post(socket, socket.assigns.action, post_params)
  end

  defp save_post(socket, :edit, post_params) do
    case Board.update_post(socket.assigns.post, post_params) do
      {:ok, post} ->
        notify_parent({:saved, post})

        {:noreply,
         socket
         |> put_flash(:info, "Post updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_post(socket, :new, post_params) do
    post_params = Map.merge(post_params, %{
      "forum_id" => socket.assigns.forum_id,
      "topic_id" => socket.assigns.topic_id,
      "poster_id" => socket.assigns.poster_id
    })

    case Board.create_post(post_params) do
      {:ok, post} ->
        post.topic_id
        |> Board.get_topic!()
        |> Board.update_topic(%{
          last_poster: post.poster_id,
          most_recent_post_id: post.id,
          last_post_time: post.inserted_at
        })

        notify_parent({:new_post, post})

        blank_changeset = Board.change_post(%Board.Post{})

        preloaded_post = Board.get_post!(post.id, preload: [:poster])

        PubSub.broadcast(
          Apollo.PubSub,
          "topic_posts:#{post.topic_id}",
          %{
            channel: :topic_posts,
            event: :new_post,
            post: preloaded_post
          }
        )

        {:noreply,
         socket
         |> put_flash(:info, "Post created successfully")
         |> assign_form(blank_changeset)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
