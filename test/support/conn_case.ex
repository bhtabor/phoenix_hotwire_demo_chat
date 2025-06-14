defmodule PhoenixDemoChatWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use PhoenixDemoChatWeb.ConnCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # The default endpoint for testing
      @endpoint PhoenixDemoChatWeb.Endpoint

      use PhoenixDemoChatWeb, :verified_routes

      # Import conveniences for testing with connections
      import Plug.Conn
      import Phoenix.ConnTest
      import PhoenixDemoChatWeb.ConnCase
    end
  end

  setup tags do
    PhoenixDemoChat.DataCase.setup_sandbox(tags)
    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end

  @doc """
  Asserts the given status code, that we have a turbo stream response and
  returns the response body if one was set or sent.

  ## Examples

      assert turbo_stream_response(conn, 200) =~ "<turbo_stream>"
  """
  @spec turbo_stream_response(Plug.Conn.t(), status :: integer | atom) :: String.t()
  def turbo_stream_response(conn, status) do
    body = Phoenix.ConnTest.response(conn, status)
    _ = Phoenix.ConnTest.response_content_type(conn, :turbo_stream)
    body
  end
end
