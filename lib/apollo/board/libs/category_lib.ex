defmodule Apollo.Board.CategoryLib do
  @moduledoc false
  import Ecto.Query, warn: false
  alias Apollo.Repo
  alias Apollo.QueryHelpers

  alias Apollo.Board.Category

  # Queries
  @spec query_categories(list) :: Ecto.Query.t()
  def query_categories(args) do
    query = from(categories in Category)

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
    from categories in query,
      where: categories.id == ^id
  end

  defp _where(query, :name, name) do
    from categories in query,
      where: categories.name == ^name
  end

  defp _where(query, :id_in, id_list) do
    from categories in query,
      where: categories.id in ^id_list
  end

  defp _where(query, :visible, value) do
    from categories in query,
      where: categories.visible == ^value
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
    from categories in query,
      order_by: [asc: categories.name]
  end

  defp _order_by(query, "Name (Z-A)") do
    from categories in query,
      order_by: [desc: categories.name]
  end

  defp _order_by(query, "Ordering (Low-High)") do
    from categories in query,
      order_by: [asc: categories.ordering]
  end

  defp _order_by(query, "Ordering (High-Low)") do
    from categories in query,
      order_by: [desc: categories.ordering]
  end

  @spec do_preload(Ecto.Query.t(), List.t() | nil) :: Ecto.Query.t()
  defp do_preload(query, nil), do: query

  defp do_preload(query, _preloads) do
    query
  end

  @spec get_next_category_ordering_value() :: non_neg_integer()
  def get_next_category_ordering_value do
    result = Repo.one(
      from categories in Category,
        order_by: [desc: categories.ordering],
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
