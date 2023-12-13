defmodule PrenixComponents.Spinner do
  use Phoenix.Component
  import PrenixComponents.Helpers

  attr :base_class, :string, default: nil
  attr :content_class, :string, default: nil
  attr :size, :string, default: "md", values: ~w(sm md lg)

  attr :color, :string,
    default: "current",
    values: ~w(current default primary secondary success warning danger)

  def spinner(assigns) do
    assigns = set_assigns(assigns)

    ~H"""
    <div aria-label="Loading" class={@base_class}>
      <div class={@content_class}>
        <span class="sr-only">Loading...</span>
        <i class="spinner-icon-solid" />
        <i class="spinner-icon-dotted" />
      </div>
    </div>
    """
  end

  defp set_assigns(assigns) do
    base_class =
      combine_class([
        "spinner-base",
        "spinner-#{assigns.color}",
        "spinner-#{assigns.size}",
        "#{assigns.base_class}"
      ])

    content_class =
      combine_class([
        "spinner-content",
        assigns.content_class
      ])

    assigns |> assign(:base_class, base_class) |> assign(:content_class, content_class)
  end
end
