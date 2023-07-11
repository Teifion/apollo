defmodule ApolloWeb.TopicLive.CreateNewFormComponent do
  use ApolloWeb, :live_component

  alias Apollo.Board

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage topic records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="topic-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:title]} type="text" label="Title" />
        <.input field={@form[:content]} type="textarea" label="Content" />

        <:actions>
          <.button phx-disable-with="Saving...">Save Topic</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{topic: topic} = assigns, socket) do
    changeset = Board.change_topic_with_post(topic)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"topic" => topic_params}, socket) do
    changeset =
      socket.assigns.topic
      |> Board.change_topic_with_post(topic_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"topic" => topic_params}, socket) do
    save_topic(socket, socket.assigns.action, topic_params)
  end

  defp save_topic(socket, :edit, topic_params) do
    case Board.update_topic(socket.assigns.topic, topic_params) do
      {:ok, topic} ->
        notify_parent({:saved, topic})

        {:noreply,
         socket
         |> put_flash(:info, "Topic updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_topic(socket, :new_topic, topic_params) do
    topic_params = Map.merge(topic_params, %{
      "forum_id" => socket.assigns.forum.id,
      "creator_id" => socket.assigns.current_user.id,
      "last_poster_id" => socket.assigns.current_user.id
    })

    case Board.create_topic(topic_params) do
      {:ok, topic} ->
        {:ok, post} = Board.create_post(%{
          "content" => topic_params["content"],
          "topic_id" => topic.id,
          "forum_id" => topic.forum_id,
          "poster_id" => topic.creator_id
        })

        {:ok, _topic} = Board.update_topic(topic, %{
          last_post_time: Timex.now(),
          post_count: 1,
          most_recent_post_id: post.id
        })

        notify_parent({:new_topic, topic})

        {:noreply,
         socket
         |> put_flash(:info, "Topic created successfully")
         |> redirect(to: ~p"/board/topic/#{topic.id}")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
