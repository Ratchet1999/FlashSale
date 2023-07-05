import consumer from "channels/consumer"

consumer.subscriptions.create({channel: "DealStatusChannel"} , {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    const dealId = data.deal_id;
    const quantity = data.quantity;

    if (quantity === 0) {
      const dealQuantityElement = document.getElementById(`deal_button_${dealId}`);
      if (dealQuantityElement) {
        dealQuantityElement.innerText = "Sold Out";
        dealQuantityElement.disabled = true;
      }
    }
    else{
      const dealQuantityElement = document.getElementById(`deal_button_${dealId}`);
      if (dealQuantityElement) {
        dealQuantityElement.innerText = "Buy";
        dealQuantityElement.disabled = false;
      }
    }
  }
});
