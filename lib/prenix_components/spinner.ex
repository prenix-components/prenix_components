defmodule PrenixComponents.Spinner do
  use Phoenix.Component
  import PrenixComponents.Helpers

  @sizes ["sm", "md", "lg"]

  @colors [
    "default",
    "primary",
    "secondary",
    "success",
    "warning",
    "error",
    "current"
  ]

  attr :class, :string, default: nil
  attr :icon_class, :string, default: nil
  attr :size, :string, default: "md", values: @sizes
  attr :color, :string, default: "default", values: @colors

  def spinner(assigns) do
    assigns = set_assigns(assigns)

    ~H"""
    <div aria-label="Loading" class={@class}>
      <div class="spinner-content">
        <span class="sr-only">Loading...</span>
        <i class="spinner-icon-solid" />
        <i class="spinner-icon-dotted" />
      </div>
    </div>
    """
  end

  defp set_assigns(assigns) do
    class =
      combine_class([
        "spinner",
        "spinner-#{assigns.color}",
        "spinner-#{assigns.size}",
        "#{assigns.class}"
      ])

    assign(assigns, :class, class)
  end
end
