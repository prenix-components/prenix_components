defmodule PrenixComponents.Popover do
  use Phoenix.Component
  import PrenixComponents.Helpers
  import PrenixComponents.Icon
  import PrenixComponents.Divider

  @placements %{
    "dropdown" => "dropdown",
    "dropdown-center" => "dropdown-center",
    "dropup" => "dropup",
    "dropup-center" => "dropup-center dropup ",
    "dropend" => "dropend",
    "dropstart" => "dropstart"
  }

  @offsets %{
    "dropdown" => "0, 8",
    "dropdown-center" => "0, 8",
    "dropup" => "0, 8",
    "dropup-center" => "0, 8",
    "dropend" => "8, 0",
    "dropstart" => "8, 0"
  }

  attr :class, :string, default: nil
  attr :toggle_class, :string, default: nil
  attr :popover_class, :string, default: nil
  attr :placement, :string, default: "dropdown-center", values: Map.keys(@placements)
  attr :offset, :string, default: nil
  slot :toggle, required: true
  slot :inner_block, required: true

  def popover(assigns) do
    assigns = set_assigns(assigns)

    ~H"""
    <div class={@class} data-popover>
      <div
        class={@toggle_class}
        data-bs-toggle="dropdown"
        aria-expanded="false"
        data-bs-offset={@offset}
        data-bs-auto-close="outside"
      >
        <%= render_slot(@toggle) %>
      </div>

      <div class="dropdown-menu">
        <div class={@popover_class}>
          <%= render_slot(@inner_block) %>
        </div>
      </div>
    </div>
    """
  end

  defp set_assigns(assigns) do
    class =
      combine_class([
        "popover #{@placements[assigns.placement]}",
        assigns.class
      ])

    toggle_class =
      combine_class([
        "popover-toggle",
        assigns.toggle_class
      ])

    popover_class =
      combine_class([
        "popover",
        assigns.popover_class
      ])

    offset =
      cond do
        assigns.offset -> assigns.offset
        @offsets[assigns.offset] -> @offsets[assigns.offset]
        true -> "0, 8"
      end

    assigns
    |> assign(:class, class)
    |> assign(:toggle_class, toggle_class)
    |> assign(:popover_class, popover_class)
    |> assign(:offset, offset)
  end
end
