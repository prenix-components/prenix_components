defmodule PrenixComponents.Table do
  use Phoenix.Component
  import PrenixComponents.Helpers

  attr :rows, :list, required: true
  attr :class, :string, default: nil
  attr :table_class, :string, default: nil
  attr :th_class, :string, default: nil
  attr :td_class, :string, default: nil
  attr :empty_state_message, :string, default: nil

  slot :header do
    attr :class, :string
  end

  slot :col do
    attr :class, :string
  end

  def table(assigns) do
    assigns = set_assigns(assigns)

    ~H"""
    <div class={@class}>
      <table class={@table_class}>
        <%!-- <caption :if={length(@caption) > 0} class="table-caption">
        <%= render_slot(@caption) %>
      </caption> --%>
        <thead :if={@header} class="thead [&>tr]:first:rounded-lg">
          <tr class="tr">
            <th :for={header <- @header} class={[@th_class, Map.get(header, :class)]}>
              <%= render_slot(header) %>
            </th>
          </tr>
        </thead>
        <tbody class="tbody">
          <%= if @rows != [] do %>
            <tr :for={row <- @rows} class="tr">
              <td :for={{col, _i} <- Enum.with_index(@col)} class={[@td_class, Map.get(col, :class)]}>
                <%= render_slot(col, row) %>
              </td>
            </tr>
          <% else %>
            <tr class="tr">
              <td class="td td--empty-state" colspan={length(@header)}>
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
    class =
      combine_class(["table", assigns.class])

    table_class =
      combine_class(["table-el", assigns.table_class])

    th_class =
      combine_class(["th group", assigns.th_class])

    td_class =
      combine_class(["td", assigns.td_class])

    assigns
    |> assign(:class, class)
    |> assign(:table_class, table_class)
    |> assign(:th_class, th_class)
    |> assign(:td_class, td_class)
  end
end
