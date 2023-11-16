defmodule PrenixComponents.Badge do
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
  attr :size, :string, default: "md", values: @sizes
  slot :inner_block

  def badge(assigns) do
    assigns = set_assigns(assigns)

    ~H"""
    <div class={@class}>
      <span class="badge-content">
        <%= render_slot(@inner_block) %>
      </span>
    </div>
    """
  end

  defp set_assigns(assigns) do
    class =
      combine_class([
        "badge",
        "badge-#{assigns.color}",
        "badge-#{assigns.variant}",
        "badge-#{assigns.size}",
        "#{assigns.class}"
      ])

    assign(assigns, :class, class)
  end
end
