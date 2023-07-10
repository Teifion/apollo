defmodule Apollo.Board.Forum do
  use Ecto.Schema
  import Ecto.Changeset

  schema "forums" do
    field :description, :string
    field :name, :string
    field :ordering, :integer

    belongs_to :category, Apollo.Board.Category
    belongs_to :most_recent_topic, Apollo.Board.Topic

    timestamps()
  end

  @doc false
  def changeset(forum, attrs) do
    forum
    |> cast(attrs, ~w(name description ordering category_id most_recent_topic_id)a)
    |> validate_required(~w(name description ordering category_id)a)
  end
end
