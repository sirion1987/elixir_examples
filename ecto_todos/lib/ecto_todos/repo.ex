defmodule EctoTodos.Repo do
  use Ecto.Repo,
    otp_app: :ecto_todos,
    adapter: Ecto.Adapters.Postgres
end
