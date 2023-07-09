defmodule Apollo.Board.Forum do
  use Ecto.Schema
  import Ecto.Changeset

  schema "forums" do
    field :description, :string
    field :name, :string
    field :ordering, :integer
    field :category_id, :id

    timestamps()
  end

  @doc false
  def changeset(forum, attrs) do
    forum
    |> cast(attrs, [:name, :description, :ordering])
    |> validate_required([:name, :description, :ordering])
  end
end
