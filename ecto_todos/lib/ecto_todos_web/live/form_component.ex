defmodule EctoTodosWeb.FormComponent do
  use EctoTodosWeb, :live_component

  alias EctoTodos.Todos

  def render(assigns) do
    ~L"""
      <%= form_for @changeset,
          "#",
          [
            id: "todo-form",
            phx_target: @myself,
            phx_change: "validate",
            phx_submit: "save"
          ], fn f -> %>
        <%= text_input f,
            :title,
            placeholder: "What do you want to get done?" %>
        <%= error_tag f, :title %>
        <%= submit "Save", phx_disable_with: "Saving..." %>
      <% end %>
    """
  end

  def update(%{todo: todo} = assigns, socket) do
    changeset = Todos.change_todo(todo)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  def handle_event("validate", %{"todo" => params}, socket) do
    changeset =
      %EctoTodos.Todos.Todo{}
      |> Todos.change_todo(params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("save", %{"todo" => todo_params}, socket) do
    case Todos.update_todo(socket.assigns.todo, todo_params) do
      {:ok, _todo} ->
        {:noreply,
         socket
         |> put_flash(:info, "Todo updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
