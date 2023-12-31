defmodule PrenixComponents.Card do
  use Phoenix.Component
  import PrenixComponents.Helpers
  import PrenixComponents.Divider

  attr :class, :string, default: nil
  attr :body_class, :string, default: nil

  slot :header do
    attr :divider, :boolean
    attr :class, :string
  end

  slot :body do
    attr :class, :string
  end

  slot :footer do
    attr :divider, :boolean
    attr :class, :string
    attr :blurred, :boolean
  end

  slot :inner_block

  def card(assigns) do
    assigns = set_assigns(assigns)

    ~H"""
    <div class={@class} tabindex="-1">
      <%= for header <- @header do %>
        <div class={["card-header", Map.get(header, :class, "")]}>
          <%= render_slot(header) %>
        </div>

        <%= if Map.get(header, :divider, false) do %>
          <.divider />
        <% end %>
      <% end %>

      <%= for body <- @body do %>
        <div class={["card-body", Map.get(body, :class, "")]}>
          <%= render_slot(body) %>
        </div>
      <% end %>

      <%= render_slot(@inner_block) %>

      <%= for footer <- @footer do %>
        <%= if Map.get(footer, :divider, false) do %>
          <.divider />
        <% end %>

        <div class={[
          "card-footer",
          Map.get(footer, :class, ""),
          if(Map.get(footer, :blurred, false), do: "card-footer-blurred", else: "")
        ]}>
          <%= render_slot(footer) %>
        </div>
      <% end %>
    </div>
    """
  end

  defp set_assigns(assigns) do
    class =
      combine_class([
        "card",
        "#{assigns.class}"
      ])

    assigns
    |> assign(:class, class)
  end
end
