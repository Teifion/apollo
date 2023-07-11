defmodule Apollo.Board.TopicLib do
  import Ecto.Query, warn: false
  alias Apollo.Repo
  alias Apollo.QueryHelpers

  alias Apollo.Board.Topic

  # Queries
  @spec query_topics(list) :: Ecto.Query.t()
  def query_topics(args) do
    query = from(topics in Topic)

    query
    |> do_where([id: args[:id]])
    |> do_where(args[:where])
    |> do_preload(args[:preload])
    |> do_order_by(args[:order_by])
    |> QueryHelpers.select(args[:select])
  end

  @spec do_where(Ecto.Query.t(), list | map | nil) :: Ecto.Query.t()
  defp do_where(query, nil), do: query

  defp do_where(query, params) do
    params
    |> Enum.reduce(query, fn {key, value}, query_acc ->
      _where(query_acc, key, value)
    end)
  end

  @spec _where(Ecto.Query.t(), Atom.t(), any()) :: Ecto.Query.t()
  defp _where(query, _, ""), do: query
  defp _where(query, _, nil), do: query

  defp _where(query, :id, id) do
    from topics in query,
      where: topics.id == ^id
  end

  defp _where(query, :name, name) do
    from topics in query,
      where: topics.name == ^name
  end

  defp _where(query, :id_in, id_list) do
    from topics in query,
      where: topics.id in ^id_list
  end

  defp _where(query, :forum_id, id) do
    from topics in query,
      where: topics.forum_id == ^id
  end

  defp _where(query, :forum_id_in, id_list) do
    from topics in query,
      where: topics.forum_id in ^id_list
  end

  @spec do_order_by(Ecto.Query.t(), list | nil) :: Ecto.Query.t()
  defp do_order_by(query, nil), do: query
  defp do_order_by(query, params) do
    params
    |> Enum.reduce(query, fn key, query_acc ->
      _order_by(query_acc, key)
    end)
  end

  defp _order_by(query, nil), do: query

  defp _order_by(query, "Newest first") do
    from topics in query,
      order_by: [desc: topics.updated_at]
  end

  defp _order_by(query, "Oldest first") do
    from topics in query,
      order_by: [asc: topics.updated_at]
  end

  @spec do_preload(Ecto.Query.t(), List.t() | nil) :: Ecto.Query.t()
  defp do_preload(query, nil), do: query

  defp do_preload(query, preloads) do
    preloads
    |> Enum.reduce(query, fn key, query_acc ->
      _preload(query_acc, key)
    end)
  end

  defp _preload(query, :most_recent_post) do
    from topics in query,
      left_join: posts in assoc(topics, :most_recent_post),
      preload: [most_recent_post: posts]
  end

  defp _preload(query, :last_poster) do
    from topics in query,
      left_join: users in assoc(topics, :last_poster),
      preload: [last_poster: users]
  end
end
