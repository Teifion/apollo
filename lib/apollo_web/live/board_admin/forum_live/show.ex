defmodule ApolloWeb.ForumLive.Show do
  use ApolloWeb, :live_view

  alias Apollo.Board

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:forum, Board.get_forum!(id))}
  end

  defp page_title(:show), do: "Show Forum"
  defp page_title(:edit), do: "Edit Forum"
end
