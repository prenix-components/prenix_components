defmodule PrenixComponents.Chip do
  use Phoenix.Component
  import PrenixComponents.Helpers

  @colors [
    "default",
    "primary",
    "secondary",
    "success",
    "warning",
    "danger"
  ]

  @variants [
    "solid",
    "soft",
    "outline"
  ]

  @sizes [
    "sm",
    "md",
    "lg"
  ]

  attr :class, :string, default: nil
  attr :color, :string, default: "default", values: @colors
  attr :variant, :string, default: "solid", values: @variants
  attr :radius, :string, default: "full", values: ~w(sm md lg full)
  attr :size, :string, default: "md", values: @sizes
  slot :inner_block

  def chip(assigns) do
    assigns = set_assigns(assigns)

    ~H"""
    <div class={@class}>
      <span class="chip-content">
        <%= render_slot(@inner_block) %>
      </span>
    </div>
    """
  end

  defp set_assigns(assigns) do
    class =
      combine_class([
        "chip",
        "chip-#{assigns.color}",
        "chip-#{assigns.variant}",
        "chip-#{assigns.size}",
        "chip-radius-#{assigns.radius}",
        "#{assigns.class}"
      ])

    assign(assigns, :class, class)
  end
end
