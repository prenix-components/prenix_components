defmodule PrenixComponents.Icon do
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

  attr(:name, :string, default: nil, doc: "Heroicon name")
  attr(:class, :string, default: nil, doc: "Additional CSS class")
  attr(:size, :string, default: "md", values: @sizes)
  attr(:variant, :string, default: "default", values: @variants)
  slot(:inner_block, doc: "Custom icon")

  def icon(assigns) do
    assigns = assign(assigns, :class, class(assigns))

    ~H"""
    <%= if @name do %>
      <%= render_heroicon(assigns) %>
    <% else %>
      <%= render_custom_icon(assigns) %>
    <% end %>
    """
  end

  defp render_heroicon(%{name: "hero-" <> _} = assigns) do
    ~H"""
    <span class={[@name, @class]} />
    """
  end

  defp render_custom_icon(assigns) do
    ~H"""
    <span class={@class}>
      <%= render_slot(@inner_block) %>
    </span>
    """
  end

  defp class(assigns) do
    combine_class([
      "icon",
      "icon-#{assigns.variant}",
      "icon-#{assigns.size}",
      "#{assigns.class}"
    ])
  end
end
