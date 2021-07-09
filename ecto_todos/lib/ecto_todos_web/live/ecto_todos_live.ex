defmodule EctoTodosWeb.TodoLive do
  use EctoTodosWeb, :live_view

  alias EctoTodos.Todos

  def mount(_params, _, socket) do
    {:ok, fetch(socket)}
  end

  def render(assigns) do
    ~L"""
      <h1>Todo List</h1>
      <%= form_for @changeset,
          "#",
          [
            id: "todo-form",
            phx_submit: "add-todo",
            phx_change: "validate"
          ], fn f -> %>
        <%= text_input :todo,
            :title,
            placeholder: "What do you want to get done?" %>
        <%= error_tag f, :title %>
        <%= submit "Add", phx_disable_with: "Adding..." %>
      <% end %>
      <ul phx-hook="InitSortable" id="items" data-target-id="#items">
        <%= for todo <- @todos do %>
          <li data-sortable-id=<%=todo.id %>>
            <%= content_tag :input,
                nil,
                type: "checkbox",
                phx_click: "toggle-todo",
                phx_value_todo_id: todo.id,
                checked: todo.completed %>
            <%= todo.title %>
            <%= live_patch "Edit",
                to: Routes.live_path(@socket, EctoTodosWeb.TodoLive, %{edit: todo.id}) %>
            <%= link "Delete",
                to: "#",
                phx_click: "delete-todo",
                phx_value_todo_id: todo.id,
                data: [confirm: "Are you sure?"] %>
          </li>
        <% end %>
      </ul>
      <footer>
        <%= live_patch "All",
            to: Routes.live_path(@socket, EctoTodosWeb.TodoLive),
            class: "button" %>
        <%= live_patch "Completed",
            to: Routes.live_path(@socket, EctoTodosWeb.TodoLive, %{filter: "completed"}),
            class: "button" %>
      </footer>

      <%= if @show_edit_modal do %>
        <%= live_modal @socket,
            EctoTodosWeb.FormComponent,
            id: @todo.id,
            title: "Edit",
            action: @live_action,
            todo: @todo,
            return_to: Routes.live_path(@socket, EctoTodosWeb.TodoLive) %>
      <% end %>
    """
  end

  def handle_event("add-todo", %{"todo" => params}, socket) do
    case Todos.create_todo(params) do
      {:ok, _todo} ->
        {:noreply, fetch(socket)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, fetch(socket)}
    end
  end

  def handle_event("delete-todo", %{"todo-id" => id}, socket) do
    todo = Todos.get_todo!(id)
    {:ok, _} = Todos.delete_todo(todo)

    {:noreply, fetch(socket)}
  end

  def handle_event("validate", %{"todo" => params}, socket) do
    changeset =
      %EctoTodos.Todos.Todo{}
      |> Todos.change_todo(params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("toggle-todo", %{"todo-id" => id}, socket) do
    todo = Todos.get_todo!(id)
    {:ok, _} = Todos.toggle_todo(todo)

    {:noreply, socket}
  end

  def handle_params(%{"filter" => filter}, _uri, socket) do
    {:noreply,
     socket
     |> assign(:todos, Todos.list_completed_todos())
     |> assign(:filter, filter)
    }
  end

  def handle_params(%{"edit" => id}, _uri, socket) do
    todo = Todos.get_todo(id)

    case todo do
      nil ->
        {:noreply,
         socket
         |> put_flash(:info, "Todo not found")}
      _ ->
        {:noreply,
         socket
         |> assign(:show_edit_modal, true)
         |> assign(:todo, todo)}
    end
  end

  def handle_params(_params, _uri, socket) do
    {:noreply, fetch(socket)}
  end

  def handle_event("sort", %{"list" => list}, socket) do
    list
    |> Enum.each(fn %{"id" => id, "position" => position} ->
      Todos.get_todo!(id)
      |> Todos.update_todo(%{"position" => position})
    end)

    {:noreply, socket}
  end

  defp fetch(socket) do
    assign(socket, %{
      changeset: Todos.change_todo(%EctoTodos.Todos.Todo{}),
      show_edit_modal: false,
      todo: nil,
      todos: Todos.list_todos()
    })
  end
end
