defmodule PhoenixDemoChatWeb.TurboStreamChannel do
  use PhoenixDemoChatWeb, :channel

  @impl true
  def join(topic, %{"signed_topic" => signed_topic}, socket) do
    case PhoenixDemoChatWeb.Token.verify(socket, signed_topic) do
      {:ok, ^topic} ->
        {:ok, socket}

      _ ->
        {:error, %{reason: "unauthorized"}}
    end
  end

  def join(_topic, _payload, _socket) do
    {:error, %{reason: "unauthorized"}}
  end
end
