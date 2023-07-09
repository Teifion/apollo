defmodule Apollo.Board.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :content, :string
    field :subject, :string
    field :topic_id, :id
    field :forum_id, :id
    field :poster_id, :id

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:content, :subject])
    |> validate_required([:content, :subject])
  end
end
