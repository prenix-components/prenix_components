defmodule PrenixComponents.Tooltip do
  use Phoenix.Component
  import PrenixComponents.Helpers

  attr :base_class, :string, default: nil
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
      class={@base_class}
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
    base_class =
      combine_class([
        "tooltip-base",
        assigns.base_class
      ])

    tooltip_class =
      combine_class([
        "tooltip-#{assigns.color}",
        assigns.tooltip_class,
        if(assigns.arrow, do: "tooltip-arrow", else: nil)
      ])

    assigns
    |> assign(:base_class, base_class)
    |> assign(:tooltip_class, tooltip_class)
  end
end
