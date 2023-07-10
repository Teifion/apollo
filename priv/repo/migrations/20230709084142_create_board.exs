defmodule Apollo.Repo.Migrations.CreateBoard do
  use Ecto.Migration

  def change do
    create table(:categories) do
      add :name, :string
      add :visible, :boolean
      add :ordering, :integer

      timestamps()
    end

    create table(:forums) do
      add :name, :string
      add :description, :text
      add :ordering, :integer
      add :category_id, references(:categories, on_delete: :nothing)

      timestamps()
    end

    create index(:forums, [:category_id])

    create table(:topics) do
      add :title, :string
      add :last_post_time, :naive_datetime
      add :post_count, :integer
      add :forum_id, references(:forums, on_delete: :nothing)
      add :creator_id, references(:users, on_delete: :nothing)
      add :last_poster_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:topics, [:forum_id])
    create index(:topics, [:creator_id])
    create index(:topics, [:last_poster_id])

    create table(:posts) do
      add :content, :text
      add :subject, :string
      add :topic_id, references(:topics, on_delete: :nothing)
      add :forum_id, references(:forums, on_delete: :nothing)
      add :poster_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:posts, [:topic_id])
    create index(:posts, [:forum_id])
    create index(:posts, [:poster_id])

    alter table(:forums) do
      add :most_recent_topic_id, references(:topics, on_delete: :nothing)
    end
  end
end
