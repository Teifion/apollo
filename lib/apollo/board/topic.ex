defmodule Apollo.Board.Topic do
  use Ecto.Schema
  import Ecto.Changeset

  schema "topics" do
    field :last_post_time, :naive_datetime
    field :post_count, :integer
    field :title, :string
    field :forum_id, :id
    field :creator_id, :id
    field :last_poster_id, :id

    timestamps()
  end

  @doc false
  def changeset(topic, attrs) do
    topic
    |> cast(attrs, [:title, :last_post_time, :post_count])
    |> validate_required([:title, :last_post_time, :post_count])
  end
end
