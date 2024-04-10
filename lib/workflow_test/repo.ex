defmodule WorkflowTest.Repo do
  use Ecto.Repo,
    otp_app: :workflow_test,
    adapter: Ecto.Adapters.Postgres
end
