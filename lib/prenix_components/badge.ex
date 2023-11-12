defmodule PrenixComponents.Badge do
  use Phoenix.Component
  import PrenixComponents.Helpers

  @variants [
    "primary",
    "secondary",
    "success",
    "error",
    "warning",
    "neutral"
  ]

  attr(:class, :string, default: nil, doc: "Additional CSS class")
  attr(:soft, :boolean, default: false, doc: "Indicates soft variant")
  attr(:outline, :boolean, default: false, doc: "Indicates outline variant")
  attr(:rounded, :boolean, default: false, doc: "Indicates rounded badge")
  attr(:variant, :string, default: "primary", values: @variants)
  slot(:inner_block)

  def badge(assigns) do
    assigns = assign(assigns, :class, class(assigns))

    ~H"""
    <span class={@class}>
      <%= render_slot(@inner_block) %>
    </span>
    """
  end

  defp class(assigns) do
    combine_class([
      "badge",
      "badge-#{assigns.variant}",
      if(assigns.soft, do: "badge-soft", else: nil),
      if(assigns.rounded, do: "badge-rounded", else: nil),
      if(assigns.outline, do: "badge-outline", else: nil),
      "#{assigns.class}"
    ])
  end
end
