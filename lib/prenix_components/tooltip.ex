defmodule PrenixComponents.Tooltip do
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

  @placements [
    "top",
    "bottom",
    "right",
    "left"
  ]

  attr :class, :string, default: nil
  attr :color, :string, default: "default", values: @colors
  attr :placement, :string, default: "top", values: @placements
  attr :title, :string, required: true
  slot :inner_block

  def tooltip(assigns) do
    assigns = set_assigns(assigns)

    ~H"""
    <span
      class={@class}
      data-bs-toggle="tooltip"
      data-bs-custom-class={@custom_class}
      data-bs-title={@title}
      data-bs-placement={@placement}
      data-bs-offset="0, 8"
    >
      <%= render_slot(@inner_block) %>
    </span>
    """
  end

  defp set_assigns(assigns) do
    class =
      combine_class([
        "tooltip-wrapper",
        assigns.class
      ])

    assigns |> assign(:class, class) |> assign(:custom_class, "tooltip-#{assigns.color}")
  end
end
