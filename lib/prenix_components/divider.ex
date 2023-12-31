defmodule PrenixComponents.Divider do
  import PrenixComponents.Helpers
  use Phoenix.Component

  attr :class, :string, default: nil
  attr :orientation, :string, default: "horizontal", values: ~w(horizontal vertical)
  attr :rest, :global

  def divider(assigns) do
    class =
      combine_class([
        "divider",
        "divider-#{assigns.orientation}",
        assigns.class
      ])

    assigns = assign(assigns, :class, class)

    ~H"""
    <hr class={@class} role="separator" {@rest} />
    """
  end
end
