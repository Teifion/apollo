defmodule ApolloWeb.BoardIndexLive do
  use ApolloWeb, :live_view

  alias Apollo.Board

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :categories, Board.list_categories())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    # {:noreply, apply_action(socket, socket.assigns.live_action, params)}
    {:noreply, socket}
  end

  # defp apply_action(socket, :edit, %{"id" => id}) do
  #   socket
  #   |> assign(:page_title, "Edit Category")
  #   |> assign(:category, Board.get_category!(id))
  # end

  # defp apply_action(socket, :new, _params) do
  #   socket
  #   |> assign(:page_title, "New Category")
  #   |> assign(:category, %Category{})
  # end

  # defp apply_action(socket, :index, _params) do
  #   socket
  #   |> assign(:page_title, "Listing Categories")
  #   |> assign(:category, nil)
  # end

  # @impl true
  # def handle_info({ApolloWeb.CategoryLive.FormComponent, {:saved, category}}, socket) do
  #   {:noreply, stream_insert(socket, :categories, category)}
  # end

  # @impl true
  # def handle_event("delete", %{"id" => id}, socket) do
  #   category = Board.get_category!(id)
  #   {:ok, _} = Board.delete_category(category)

  #   {:noreply, stream_delete(socket, :categories, category)}
  # end
end
