defmodule ApolloWeb.BoardLive.Topic do
  use ApolloWeb, :live_view

  alias Apollo.Board
  alias Phoenix.PubSub

  @impl true
  def mount(%{"topic_id" => topic_id}, _session, socket) do
    topic = Board.get_topic!(topic_id)
    posts = Board.list_posts(
      where: [
        topic_id: topic_id
      ],
      preload: [
        :poster
      ],
      order_by: [
        "Newest first"
      ],
      limit: 25
    )
    |> Enum.reverse

    PubSub.subscribe(Apollo.PubSub, "topic_posts:#{topic_id}")

    socket = socket
      |> assign(:topic, topic)
      |> stream(:posts, posts)

    {:ok, socket}
  end

  @impl true
  def handle_params(_params, _url, socket) do
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

  @impl true
  def handle_info({ApolloWeb.PostLive.FormComponent, {:new_post, _post}}, socket) do
    {:noreply, socket}
  end

  def handle_info(%{channel: :topic_posts, event: :new_post} = msg, socket) do
    {:noreply, stream_insert(socket, :posts, msg.post)}
  end

  # @impl true
  # def handle_event("delete", %{"id" => id}, socket) do
  #   category = Board.get_category!(id)
  #   {:ok, _} = Board.delete_category(category)

  #   {:noreply, stream_delete(socket, :categories, category)}
  # end
end
