defmodule Apollo.Board.Category do
  use Ecto.Schema
  import Ecto.Changeset

  schema "categories" do
    field :name, :string
    field :visible, :boolean, default: true
    field :ordering, :integer

    timestamps()
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, ~w(name visible ordering)a)
    |> validate_required(~w(name visible)a)
  end
end
