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
    "top-left",
    "top-right",
    "bottom",
    "bottom-left",
    "bottom-right",
    "right",
    "right-top",
    "right-bottom",
    "left",
    "left-top",
    "left-bottom"
  ]

  attr :class, :string, default: nil
  attr :color, :string, default: "default", values: @colors
  attr :placement, :string, default: "top", values: @placements
  slot :content, required: true
  slot :inner_block

  def tooltip(assigns) do
    assigns = set_assigns(assigns)

    ~H"""
    <div class={@class} data-placement={@placement}>
      <span class="hs-tooltip-content tooltip-content-wrapper" role="tooltip">
        <span class="tooltip-content">
          <%= render_slot(@content) %>
        </span>
      </span>

      <div class="hs-tooltip-toggle tooltip-toggle">
        <%= render_slot(@inner_block) %>
      </div>
    </div>
    """
  end

  defp set_assigns(assigns) do
    class =
      combine_class([
        "hs-tooltip tooltip",
        "tooltip-#{assigns.color}",
        assigns.class
      ])

    assigns |> assign(:class, class)
  end
end
