defmodule Apollo.BoardFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Apollo.Board` context.
  """

  @doc """
  Generate a category.
  """
  def category_fixture(attrs \\ %{}) do
    {:ok, category} =
      attrs
      |> Enum.into(%{
        name: "some name",
        ordering: 42
      })
      |> Apollo.Board.create_category()

    category
  end

  @doc """
  Generate a forum.
  """
  def forum_fixture(attrs \\ %{}) do
    {:ok, forum} =
      attrs
      |> Enum.into(%{
        description: "some description",
        name: "some name",
        ordering: 42
      })
      |> Apollo.Board.create_forum()

    forum
  end

  @doc """
  Generate a topic.
  """
  def topic_fixture(attrs \\ %{}) do
    {:ok, topic} =
      attrs
      |> Enum.into(%{
        last_post_time: ~N[2023-07-08 08:41:00],
        post_count: 42,
        title: "some title"
      })
      |> Apollo.Board.create_topic()

    topic
  end

  @doc """
  Generate a post.
  """
  def post_fixture(attrs \\ %{}) do
    {:ok, post} =
      attrs
      |> Enum.into(%{
        content: "some content",
        subject: "some subject"
      })
      |> Apollo.Board.create_post()

    post
  end
end
