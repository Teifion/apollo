defmodule ApolloWeb.BoardLive.Forum do
  @moduledoc false
  use ApolloWeb, :live_view

  alias Apollo.Board
  alias Apollo.Board.Topic

  @impl true
  def mount(params, _session, socket) do
    forum = Board.get_forum!(params["forum_id"])
    topics = Board.list_topics(
      where: [
        forum_id: forum.id
      ],
      preload: [
        :most_recent_post,
        :last_poster
      ],
      order_by: [
        "Newest first"
      ],
      limit: 25
    )

    socket = socket
      |> assign(:forum, forum)
      |> stream(:topics, topics)

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  # defp apply_action(socket, :edit, %{"id" => id}) do
  #   socket
  #   |> assign(:page_title, "Edit Category")
  #   |> assign(:category, Board.get_category!(id))
  # end

  defp apply_action(socket, :new_topic, _params) do
    socket
    |> assign(:page_title, "New Topic")
    |> assign(:topic, %Topic{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing topics")
    |> assign(:topic, nil)
  end

  # @impl true
  # def handle_info({ApolloWeb.TopicLive.CreateNewFormComponent, {:new_topic, topic}}, socket) do
  #   {:noreply, socket |> push_patch(to: ~p"/board/topic/#{topic.id}")}
  # end

  # @impl true
  # def handle_event("delete", %{"id" => id}, socket) do
  #   category = Board.get_category!(id)
  #   {:ok, _} = Board.delete_category(category)

  #   {:noreply, stream_delete(socket, :categories, category)}
  # end
end
