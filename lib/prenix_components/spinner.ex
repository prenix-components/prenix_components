defmodule PrenixComponents.Spinner do
  use Phoenix.Component
  import PrenixComponents.Helpers

  @sizes ["sm", "md", "lg"]
  @variants [
    "default",
    "primary",
    "secondary",
    "success",
    "error",
    "warning",
    "neutral"
  ]

  attr(:class, :string, default: nil, doc: "Additional CSS class")
  attr(:size, :string, default: "md", values: @sizes)
  attr(:variant, :string, default: "default", values: @variants)
  slot(:inner_block)

  def spinner(assigns) do
    assigns = assign(assigns, :class, class(assigns))

    ~H"""
    <span class={@class} role="progressbar" aria-label="Loading">
      <span class="sr-only">Loading...</span>
    </span>
    """
  end

  defp class(assigns) do
    combine_class([
      "spinner",
      "spinner-#{assigns.variant}",
      "spinner-#{assigns.size}",
      "#{assigns.class}"
    ])
  end
end
