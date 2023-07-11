defmodule Apollo.Board.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :content, :string

    belongs_to :topic, Apollo.Board.Topic
    belongs_to :forum, Apollo.Board.Forum
    belongs_to :poster, Apollo.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:content, :topic_id, :forum_id, :poster_id])
    |> validate_required([:content, :topic_id, :forum_id, :poster_id])
  end
end
