# frozen_string_literal: true

class WebRateUpdateChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'web_rate_update_channel'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
