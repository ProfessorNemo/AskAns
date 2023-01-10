import consumer from "./consumer"

consumer.subscriptions.create("WebRateUpdateChannel", {
  connected() {
    console.log("WebRateUpdateChannel connected");
  },

  disconnected() {
    console.log("WebRateUpdateChannel disconnected");
  },

  received(data) {
    console.log(`WebRateUpdateChannel received data: ${data.content}`);
    $('#current_rate').html(data.content);
  }
});
