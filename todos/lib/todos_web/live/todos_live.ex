defmodule TodosWeb.TodosLive do
  use TodosWeb, :live_view

  def mount(params, _, socket) do
    {:ok, assign(socket, todos: [])}
  end

  def render(assigns) do
    ~L"""
      <h1>Todo List</h1>
      <form phx-submit="add-todo">
        <input type="text" name="text" />
        <input type="button" value="Reset" phx-click="reset-todos">
      </form>
      <ul>
        <%= for todo <- @todos do %>
          <li><%= todo %></li>
        <% end %>
      </ul>
    """
  end

  def handle_event("add-todo", %{"text" => ""}, socket) do
    {:noreply, socket}
  end

  def handle_event("add-todo", %{"text" => text}, socket) do
    todos = socket.assigns.todos ++ [text]

    {:noreply, assign(socket, :todos, todos)}
  end

  def handle_event("reset-todos", _, socket) do
    {:noreply, assign(socket, :todos, [])}
  end
end
