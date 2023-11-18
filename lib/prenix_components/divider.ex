defmodule PrenixComponents.Divider do
  use Phoenix.Component

  attr :class, :string, default: nil

  def divider(assigns) do
    ~H"""
    <hr class={["divider", @class]} role="separator" />
    """
  end
end
