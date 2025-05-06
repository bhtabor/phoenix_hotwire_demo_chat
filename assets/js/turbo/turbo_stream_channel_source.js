import { connectStreamSource, disconnectStreamSource } from "../../vendor/turbo"

function createTurboStreamChannelSource(socket) {
  return class TurboStreamChannelSourceElement extends HTMLElement {
    static observedAttributes = ["topic", "signed-topic"]

    async connectedCallback() {
      connectStreamSource(this)

      const topic = this.getAttribute("topic")
      const signedTopic = this.getAttribute("signed-topic")

      this.joinChannel(topic, signedTopic)
    }

    disconnectedCallback() {
      disconnectStreamSource(this)
      if (this.channel) this.channel.leave()
      this.channelDisconnected()
    }

    attributeChangedCallback() {
      if (this.channel) {
        this.disconnectedCallback()
        this.connectedCallback()
      }
    }

    joinChannel(topic, signedTopic) {
      this.channel = socket.channel(topic, { signed_topic: signedTopic })

      this.channel
        .join()
        .receive("ok", () => {
          this.channelConnected()
          if(socket.hasLogger()) socket.log("turbo-stream-channel", `connected ${topic}`)
        })
        .receive("error", (event) => {
          if(socket.hasLogger()) socket.log("turbo-stream-channel", `error ${topic}`, event)
        })
        .receive("timeout", () => {
          if(socket.hasLogger()) socket.log("turbo-stream-channel", `timeout ${topic}`)
        })

      this.channel.on("message", ({ data }) => {
        this.dispatchMessageEvent(data)
        if(socket.hasLogger()) socket.log("turbo-stream-channel", `message ${topic}`, data)
      })

      this.channel.onClose(() => {
        this.channelDisconnected()
        if(socket.hasLogger()) socket.log("turbo-stream-channel", `disconnected ${topic}`)
      })

      this.channel.onError((event) => {
        this.channelDisconnected()
        if(socket.hasLogger()) socket.log("turbo-stream-channel", `error ${topic}`, event)
      })
    }

    dispatchMessageEvent(data) {
      const event = new MessageEvent("message", { data })
      return this.dispatchEvent(event)
    }

    channelConnected() {
      this.setAttribute("connected", "")
    }

    channelDisconnected() {
      this.removeAttribute("connected")
    }
  }
}

export { createTurboStreamChannelSource }
