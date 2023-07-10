defmodule ApolloWeb.ForumLive.FormComponent do
  use ApolloWeb, :live_component

  alias Apollo.Board

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage forum records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="forum-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:category_id]} type="select" label="Category" options={@categories} />
        <.input field={@form[:description]} type="text" label="Description" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Forum</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{forum: forum} = assigns, socket) do
    categories = Board.list_categories(
      where: [
        visible: true
      ],
      order_by: [
        "Name (A-Z)"
      ],
      select: [:id, :name]
    )
    |> Enum.map(fn %{id: id, name: name} ->
      {name, id}
    end)

    changeset = Board.change_forum(forum)

    {:ok,
     socket
     |> assign(:categories, categories)
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"forum" => forum_params}, socket) do
    changeset =
      socket.assigns.forum
      |> Board.change_forum(forum_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"forum" => forum_params}, socket) do
    save_forum(socket, socket.assigns.action, forum_params)
  end

  defp save_forum(socket, :edit, forum_params) do
    case Board.update_forum(socket.assigns.forum, forum_params) do
      {:ok, forum} ->
        notify_parent({:saved, forum})

        {:noreply,
         socket
         |> put_flash(:info, "Forum updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_forum(socket, :new, forum_params) do
    next_ordering = Board.get_next_forum_ordering_value(forum_params["category_id"])
    forum_params = Map.merge(forum_params, %{
      "ordering" => next_ordering
    })

    case Board.create_forum(forum_params) do
      {:ok, forum} ->
        notify_parent({:saved, forum})

        {:noreply,
         socket
         |> put_flash(:info, "Forum created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
