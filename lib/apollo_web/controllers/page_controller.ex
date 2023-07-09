defmodule ApolloWeb.PageController do
  use ApolloWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    # render(conn, :home, layout: false)

    case conn.assigns[:current_user] do
      nil ->
        redirect(conn, to: ~p"/users/log_in")

      %Apollo.Accounts.User{} ->
        redirect(conn, to: ~p"/board")
    end
  end
end
