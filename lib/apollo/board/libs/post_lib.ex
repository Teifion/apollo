defmodule Apollo.Board.PostLib do
  import Ecto.Query, warn: false
  alias Apollo.Repo
  alias Apollo.QueryHelpers

  alias Apollo.Board.Post

  # Queries
  @spec query_posts(list) :: Ecto.Query.t()
  def query_posts(args) do
    query = from(posts in Post)

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
    from posts in query,
      where: posts.id == ^id
  end

  defp _where(query, :name, name) do
    from posts in query,
      where: posts.name == ^name
  end

  defp _where(query, :id_in, id_list) do
    from posts in query,
      where: posts.id in ^id_list
  end

  defp _where(query, :topic_id, id) do
    from posts in query,
      where: posts.topic_id == ^id
  end

  defp _where(query, :topic_id_in, id_list) do
    from posts in query,
      where: posts.topic_id in ^id_list
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
    from posts in query,
      order_by: [desc: posts.updated_at]
  end

  defp _order_by(query, "Oldest first") do
    from posts in query,
      order_by: [asc: posts.updated_at]
  end

  @spec do_preload(Ecto.Query.t(), List.t() | nil) :: Ecto.Query.t()
  defp do_preload(query, nil), do: query

  defp do_preload(query, _preloads) do
    query
  end
end
