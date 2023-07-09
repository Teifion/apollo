defmodule Apollo.BoardTest do
  use Apollo.DataCase

  alias Apollo.Board

  describe "categories" do
    alias Apollo.Board.Category

    import Apollo.BoardFixtures

    @invalid_attrs %{name: nil, ordering: nil}

    test "list_categories/0 returns all categories" do
      category = category_fixture()
      assert Board.list_categories() == [category]
    end

    test "get_category!/1 returns the category with given id" do
      category = category_fixture()
      assert Board.get_category!(category.id) == category
    end

    test "create_category/1 with valid data creates a category" do
      valid_attrs = %{name: "some name", ordering: 42}

      assert {:ok, %Category{} = category} = Board.create_category(valid_attrs)
      assert category.name == "some name"
      assert category.ordering == 42
    end

    test "create_category/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Board.create_category(@invalid_attrs)
    end

    test "update_category/2 with valid data updates the category" do
      category = category_fixture()
      update_attrs = %{name: "some updated name", ordering: 43}

      assert {:ok, %Category{} = category} = Board.update_category(category, update_attrs)
      assert category.name == "some updated name"
      assert category.ordering == 43
    end

    test "update_category/2 with invalid data returns error changeset" do
      category = category_fixture()
      assert {:error, %Ecto.Changeset{}} = Board.update_category(category, @invalid_attrs)
      assert category == Board.get_category!(category.id)
    end

    test "delete_category/1 deletes the category" do
      category = category_fixture()
      assert {:ok, %Category{}} = Board.delete_category(category)
      assert_raise Ecto.NoResultsError, fn -> Board.get_category!(category.id) end
    end

    test "change_category/1 returns a category changeset" do
      category = category_fixture()
      assert %Ecto.Changeset{} = Board.change_category(category)
    end
  end

  describe "forums" do
    alias Apollo.Board.Forum

    import Apollo.BoardFixtures

    @invalid_attrs %{description: nil, name: nil, ordering: nil}

    test "list_forums/0 returns all forums" do
      forum = forum_fixture()
      assert Board.list_forums() == [forum]
    end

    test "get_forum!/1 returns the forum with given id" do
      forum = forum_fixture()
      assert Board.get_forum!(forum.id) == forum
    end

    test "create_forum/1 with valid data creates a forum" do
      valid_attrs = %{description: "some description", name: "some name", ordering: 42}

      assert {:ok, %Forum{} = forum} = Board.create_forum(valid_attrs)
      assert forum.description == "some description"
      assert forum.name == "some name"
      assert forum.ordering == 42
    end

    test "create_forum/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Board.create_forum(@invalid_attrs)
    end

    test "update_forum/2 with valid data updates the forum" do
      forum = forum_fixture()
      update_attrs = %{description: "some updated description", name: "some updated name", ordering: 43}

      assert {:ok, %Forum{} = forum} = Board.update_forum(forum, update_attrs)
      assert forum.description == "some updated description"
      assert forum.name == "some updated name"
      assert forum.ordering == 43
    end

    test "update_forum/2 with invalid data returns error changeset" do
      forum = forum_fixture()
      assert {:error, %Ecto.Changeset{}} = Board.update_forum(forum, @invalid_attrs)
      assert forum == Board.get_forum!(forum.id)
    end

    test "delete_forum/1 deletes the forum" do
      forum = forum_fixture()
      assert {:ok, %Forum{}} = Board.delete_forum(forum)
      assert_raise Ecto.NoResultsError, fn -> Board.get_forum!(forum.id) end
    end

    test "change_forum/1 returns a forum changeset" do
      forum = forum_fixture()
      assert %Ecto.Changeset{} = Board.change_forum(forum)
    end
  end

  describe "topics" do
    alias Apollo.Board.Topic

    import Apollo.BoardFixtures

    @invalid_attrs %{last_post_time: nil, post_count: nil, title: nil}

    test "list_topics/0 returns all topics" do
      topic = topic_fixture()
      assert Board.list_topics() == [topic]
    end

    test "get_topic!/1 returns the topic with given id" do
      topic = topic_fixture()
      assert Board.get_topic!(topic.id) == topic
    end

    test "create_topic/1 with valid data creates a topic" do
      valid_attrs = %{last_post_time: ~N[2023-07-08 08:41:00], post_count: 42, title: "some title"}

      assert {:ok, %Topic{} = topic} = Board.create_topic(valid_attrs)
      assert topic.last_post_time == ~N[2023-07-08 08:41:00]
      assert topic.post_count == 42
      assert topic.title == "some title"
    end

    test "create_topic/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Board.create_topic(@invalid_attrs)
    end

    test "update_topic/2 with valid data updates the topic" do
      topic = topic_fixture()
      update_attrs = %{last_post_time: ~N[2023-07-09 08:41:00], post_count: 43, title: "some updated title"}

      assert {:ok, %Topic{} = topic} = Board.update_topic(topic, update_attrs)
      assert topic.last_post_time == ~N[2023-07-09 08:41:00]
      assert topic.post_count == 43
      assert topic.title == "some updated title"
    end

    test "update_topic/2 with invalid data returns error changeset" do
      topic = topic_fixture()
      assert {:error, %Ecto.Changeset{}} = Board.update_topic(topic, @invalid_attrs)
      assert topic == Board.get_topic!(topic.id)
    end

    test "delete_topic/1 deletes the topic" do
      topic = topic_fixture()
      assert {:ok, %Topic{}} = Board.delete_topic(topic)
      assert_raise Ecto.NoResultsError, fn -> Board.get_topic!(topic.id) end
    end

    test "change_topic/1 returns a topic changeset" do
      topic = topic_fixture()
      assert %Ecto.Changeset{} = Board.change_topic(topic)
    end
  end

  describe "posts" do
    alias Apollo.Board.Post

    import Apollo.BoardFixtures

    @invalid_attrs %{content: nil, subject: nil}

    test "list_posts/0 returns all posts" do
      post = post_fixture()
      assert Board.list_posts() == [post]
    end

    test "get_post!/1 returns the post with given id" do
      post = post_fixture()
      assert Board.get_post!(post.id) == post
    end

    test "create_post/1 with valid data creates a post" do
      valid_attrs = %{content: "some content", subject: "some subject"}

      assert {:ok, %Post{} = post} = Board.create_post(valid_attrs)
      assert post.content == "some content"
      assert post.subject == "some subject"
    end

    test "create_post/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Board.create_post(@invalid_attrs)
    end

    test "update_post/2 with valid data updates the post" do
      post = post_fixture()
      update_attrs = %{content: "some updated content", subject: "some updated subject"}

      assert {:ok, %Post{} = post} = Board.update_post(post, update_attrs)
      assert post.content == "some updated content"
      assert post.subject == "some updated subject"
    end

    test "update_post/2 with invalid data returns error changeset" do
      post = post_fixture()
      assert {:error, %Ecto.Changeset{}} = Board.update_post(post, @invalid_attrs)
      assert post == Board.get_post!(post.id)
    end

    test "delete_post/1 deletes the post" do
      post = post_fixture()
      assert {:ok, %Post{}} = Board.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> Board.get_post!(post.id) end
    end

    test "change_post/1 returns a post changeset" do
      post = post_fixture()
      assert %Ecto.Changeset{} = Board.change_post(post)
    end
  end
end
