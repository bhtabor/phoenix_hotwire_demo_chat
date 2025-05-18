import * as Turbo from "../../vendor/turbo"
import socket from "../user_socket.js"
import { createTurboStreamChannelSource } from "./turbo_stream_channel_source"

const TurboStreamChannelSource = createTurboStreamChannelSource(socket)

if (customElements.get("turbo-stream-channel-source") === undefined) {
  customElements.define("turbo-stream-channel-source", TurboStreamChannelSource)
}
