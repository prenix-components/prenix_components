defmodule PrenixComponents.Table do
  use Phoenix.Component
  import PrenixComponents.Helpers

  attr :rows, :list, required: true
  attr :class, :string, default: nil
  attr :wrapper_class, :string, default: nil
  attr :empty_state_message, :string, default: nil

  slot :header do
    attr :class, :string, doc: "Additional CSS class"
  end

  slot :col, required: true do
    attr :label, :string
    attr :class, :string, doc: "Additional CSS class"
  end

  def table(assigns) do
    IO.inspect(assigns, label: "table assigns")
    assigns = set_assigns(assigns)

    ~H"""
    <div class={@wrapper_class}>
      <table class={@class}>
        <%!-- <caption :if={length(@caption) > 0} class="table-caption">
        <%= render_slot(@caption) %>
      </caption> --%>
        <thead :if={@header} class="thead [&>tr]:first:rounded-lg">
          <tr class="tr">
            <th :for={header <- @header} class={["th group", Map.get(header, :class)]}>
              <%= render_slot(header) %>
            </th>
          </tr>
        </thead>
        <tbody class="tbody">
          <%= if length(@rows) > 0 do %>
            <tr :for={row <- @rows} class="tr">
              <td :for={{col, _i} <- Enum.with_index(@col)} class="td">
                <%= render_slot(col, row) %>
              </td>
            </tr>
          <% else %>
            <tr class="tr">
              <td class="td td-empty-state" colspan={length(@header)}>
                <%= if @empty_state_message do %>
                  <%= @empty_state_message %>
                <% else %>
                  No rows to display.
                <% end %>
              </td>
            </tr>
          <% end %>
        </tbody>
      </table>
    </div>
    """
  end

  defp set_assigns(assigns) do
    wrapper_class =
      combine_class(["table-wrapper", assigns.wrapper_class])

    class =
      combine_class([
        "table",
        assigns.class
      ])

    assigns
    |> assign(:wrapper_class, wrapper_class)
    |> assign(:class, class)
  end
end
