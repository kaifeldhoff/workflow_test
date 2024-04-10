defmodule WorkflowTest.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      WorkflowTestWeb.Telemetry,
      WorkflowTest.Repo,
      {DNSCluster, query: Application.get_env(:workflow_test, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: WorkflowTest.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: WorkflowTest.Finch},
      # Start a worker by calling: WorkflowTest.Worker.start_link(arg)
      # {WorkflowTest.Worker, arg},
      # Start to serve requests, typically the last entry
      WorkflowTestWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: WorkflowTest.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    WorkflowTestWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
