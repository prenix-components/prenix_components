defmodule PrenixComponents.Tooltip do
  use Phoenix.Component
  import PrenixComponents.Helpers

  attr :class, :string, default: nil
  attr :tooltip_class, :string, default: nil

  attr :color, :string,
    default: "default",
    values: ~w(default primary secondary success warning danger)

  attr :placement, :string, default: "top", values: ~w(top bottom left right)
  attr :arrow, :boolean, default: true
  attr :title, :string, required: true
  slot :inner_block

  def tooltip(assigns) do
    assigns = set_assigns(assigns)

    ~H"""
    <span
      class={@class}
      data-bs-toggle="tooltip"
      data-bs-custom-class={@tooltip_class}
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
        "tooltip-toggle",
        assigns.class
      ])

    tooltip_class =
      combine_class([
        "tooltip--#{assigns.color}",
        assigns.tooltip_class,
        if(assigns.arrow, do: "tooltip-arrow", else: nil)
      ])

    assigns
    |> assign(:class, class)
    |> assign(:tooltip_class, tooltip_class)
  end
end
