defmodule ApolloWeb.ForumLive.Index do
  use ApolloWeb, :live_view

  alias Apollo.Board
  alias Apollo.Board.Forum

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :forums, Board.list_forums())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Forum")
    |> assign(:forum, Board.get_forum!(id))
  end

  defp apply_action(socket, :new, _params) do
    categories = Board.list_categories()

    socket
    |> assign(:categories, categories)
    |> assign(:page_title, "New Forum")
    |> assign(:forum, %Forum{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Forums")
    |> assign(:forum, nil)
  end

  @impl true
  def handle_info({ApolloWeb.ForumLive.FormComponent, {:saved, forum}}, socket) do
    {:noreply, stream_insert(socket, :forums, forum)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    forum = Board.get_forum!(id)
    {:ok, _} = Board.delete_forum(forum)

    {:noreply, stream_delete(socket, :forums, forum)}
  end
end
