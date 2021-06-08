defmodule CounterWeb.CounterLive do
  use CounterWeb, :live_view

  def mount(_params, _session, socket) do
    socket = assign(socket, :count, 0)

    {:ok, socket}
  end

  def handle_event("increment", _, socket) do
    count = socket.assigns.count + 1

    {:noreply, assign(socket, :count, count)}
  end

  def handle_event("decrement", _, socket) do
    count = socket.assigns.count - 1

    {:noreply, assign(socket, :count, count)}
  end

  def handle_event("reset", _, socket) do
    {:noreply, assign(socket, :count, 0)}
  end
end
