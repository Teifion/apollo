defmodule Apollo.Board.CategoryLib do
  import Ecto.Query, warn: false
  alias Apollo.Repo

  alias Apollo.Board.Category

  @spec get_next_ordering_value() :: non_neg_integer()
  def get_next_ordering_value do
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
