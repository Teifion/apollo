defmodule Apollo.Board.Topic do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  schema "topics" do
    field :last_post_time, :naive_datetime
    field :post_count, :integer
    field :title, :string
    field :content, :string, virtual: true

    belongs_to :forum, Apollo.Board.Forum
    belongs_to :creator, Apollo.Accounts.User
    belongs_to :last_poster, Apollo.Accounts.User

    belongs_to :most_recent_post, Apollo.Board.Post

    timestamps()
  end

  @doc false
  def changeset(topic, attrs) do
    topic
    |> cast(attrs, ~w(title last_post_time post_count forum_id creator_id last_poster_id most_recent_post_id)a)
    |> validate_required(~w(title last_post_time post_count forum_id creator_id last_poster_id)a)
  end

  def changeset_with_post(topic, attrs) do
    topic
    |> cast(attrs, ~w(title content forum_id creator_id last_poster_id)a)
    |> validate_required(~w(title content forum_id creator_id last_poster_id)a)
  end
end
