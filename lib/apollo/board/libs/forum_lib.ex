defmodule Apollo.Board.ForumLib do
  import Ecto.Query, warn: false
  alias Apollo.Repo
  alias Apollo.QueryHelpers

  alias Apollo.Board.Forum

  # Queries
  @spec query_forums(list) :: Ecto.Query.t()
  def query_forums(args) do
    query = from(forums in Forum)

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
    from forums in query,
      where: forums.id == ^id
  end

  defp _where(query, :name, name) do
    from forums in query,
      where: forums.name == ^name
  end

  defp _where(query, :id_in, id_list) do
    from forums in query,
      where: forums.id in ^id_list
  end

  defp _where(query, :category_id_in, id_list) do
    from forums in query,
      where: forums.category_id in ^id_list
  end

  defp _where(query, :visible, value) do
    from forums in query,
      where: forums.visible == ^value
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

  defp _order_by(query, "Name (A-Z)") do
    from forums in query,
      order_by: [asc: forums.name]
  end

  defp _order_by(query, "Name (Z-A)") do
    from forums in query,
      order_by: [desc: forums.name]
  end

  defp _order_by(query, "Ordering (Low-High)") do
    from forums in query,
      order_by: [asc: forums.ordering]
  end

  defp _order_by(query, "Ordering (High-Low)") do
    from forums in query,
      order_by: [desc: forums.ordering]
  end

  @spec do_preload(Ecto.Query.t(), List.t() | nil) :: Ecto.Query.t()
  defp do_preload(query, nil), do: query

  @spec get_next_forum_ordering_value(non_neg_integer()) :: non_neg_integer()
  def get_next_forum_ordering_value(category_id) do
    result = Repo.one(
      from forums in Forum,
        where: forums.category_id == ^category_id,
        order_by: [desc: forums.ordering],
        select: [:ordering],
        limit: 1
    )

    case result do
      nil ->
        1
      %{ordering: ordering} ->
        ordering + 1
    end
  end
end
