### topic_posts:#{topic_id}
```elixir
%{
  channel: :topic_posts,
  event: :new_post,
  post: %Post{} # (with poster preloaded)
}
```
