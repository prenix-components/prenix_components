defmodule PrenixComponents.Divider do
  import PrenixComponents.Helpers
  use Phoenix.Component

  attr :base_class, :string, default: nil
  attr :orientation, :string, default: "horizontal", values: ~w(horizontal vertical)

  def divider(assigns) do
    base_class =
      combine_class([
        "divider",
        "divider-#{assigns.orientation}",
        assigns.base_class
      ])

    assigns = assign(assigns, :base_class, base_class)

    ~H"""
    <hr class={@base_class} role="separator" />
    """
  end
end
