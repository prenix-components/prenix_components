defmodule PrenixComponents.Chip do
  use Phoenix.Component
  import PrenixComponents.Helpers

  attr :base_class, :string, default: nil

  attr :color, :string,
    default: "default",
    values: ~w(default primary secondary success warning danger)

  attr :variant, :string, default: "solid", values: ~w(solid soft outline)
  attr :radius, :string, default: "full", values: ~w(sm md lg full)
  attr :size, :string, default: "md", values: ~w(sm md lg)
  slot :inner_block

  def chip(assigns) do
    assigns = set_assigns(assigns)

    ~H"""
    <div class={@base_class}>
      <span class="chip-content">
        <%= render_slot(@inner_block) %>
      </span>
    </div>
    """
  end

  defp set_assigns(assigns) do
    base_class =
      combine_class([
        "chip",
        "chip-#{assigns.color}",
        "chip-#{assigns.variant}",
        "chip-#{assigns.size}",
        "chip-radius-#{assigns.radius}",
        "#{assigns.base_class}"
      ])

    assign(assigns, :base_class, base_class)
  end
end
