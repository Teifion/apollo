defmodule Apollo.Board.ForumLib do
  import Ecto.Query, warn: false
  alias Apollo.Repo

  alias Apollo.Board.Forum

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
