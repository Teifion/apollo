defmodule Apollo.Board.Topic do
  use Ecto.Schema
  import Ecto.Changeset

  schema "topics" do
    field :last_post_time, :naive_datetime
    field :post_count, :integer
    field :title, :string

    belongs_to :forum, Apollo.Board.Forum
    belongs_to :creator, Apollo.Accounts.User
    belongs_to :last_poster, Apollo.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(topic, attrs) do
    topic
    |> cast(attrs, ~w(title last_post_time post_count forum_id creator_id last_poster_id)a)
    |> validate_required(~w(title last_post_time post_count forum_id creator_id last_poster_id)a)
  end
end
