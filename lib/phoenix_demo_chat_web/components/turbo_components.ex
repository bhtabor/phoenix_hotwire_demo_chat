defmodule PhoenixDemoChatWeb.TurboComponents do
  use Phoenix.Component

  attr :id, :string, required: true
  attr :refresh, :string, values: ["morph"]
  attr :src, :string
  attr :loading, :string, values: ["eager", "lazy"]
  attr :disabled, :boolean
  attr :target, :string
  attr :autoscroll, :boolean
  attr :"data-autoscroll-block", :string, values: ["end", "start", "center", "nearest"]
  attr :"data-autoscroll-behavior", :string, values: ["auto", "smooth"]
  attr :rest, :global
  slot :inner_block

  def turbo_frame(assigns) do
    extra = assigns_to_attributes(assigns, [:id, :rest])
    assigns = assign(assigns, :extra, extra)

    ~H"""
    <turbo-frame id={@id} {@extra} {@rest}>
      {render_slot(@inner_block)}
    </turbo-frame>
    """
  end

  attr :action, :string,
    values: ["append", "prepend", "replace", "update", "remove", "before", "after", "refresh"],
    required: true

  attr :method, :string, values: ["morph"]
  attr :request_id, :string
  attr :target, :string
  attr :targets, :string
  slot :inner_block

  def turbo_stream(assigns) do
    assigns =
      assigns
      |> assign_new(:method, fn -> nil end)
      |> assign_new(:request_id, fn -> nil end)

    extra = assigns_to_attributes(assigns, [:action, :method, :request_id])
    assigns = assign(assigns, :extra, extra)

    ~H"""
    <turbo-stream
      action={@action}
      method={if @action in ["replace", "update"], do: @method}
      request-id={if @action == "refresh", do: @request_id}
      {@extra}
    >
      <template :if={Enum.any?(@inner_block)}>
        {render_slot(@inner_block)}
      </template>
    </turbo-stream>
    """
  end

  attr :topic, :string, required: true

  def turbo_stream_channel_source(assigns) do
    ~H"""
    <turbo-stream-channel-source topic={@topic} signed-topic={signed_topic(@topic)} />
    """
  end

  defp signed_topic(topic) do
    PhoenixDemoChatWeb.Token.sign(PhoenixDemoChatWeb.Endpoint, topic)
  end
end
