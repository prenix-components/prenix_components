defmodule PrenixComponents.Icon do
  use Phoenix.Component
  import PrenixComponents.Helpers

  @sizes ["sm", "md", "lg"]

  @colors [
    "current",
    "default",
    "primary",
    "secondary",
    "success",
    "error",
    "warning"
  ]

  attr :name, :string, default: nil, doc: "Heroicon name"
  attr :class, :string, default: nil
  attr :size, :string, default: "md", values: @sizes
  attr :color, :string, default: "current", values: @colors
  slot :inner_block, doc: "Custom icon"

  def icon(assigns) do
    assigns = set_assigns(assigns)

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

  defp set_assigns(assigns) do
    class =
      combine_class([
        "icon",
        "icon-#{assigns.color}",
        "icon-#{assigns.size}",
        "#{assigns.class}"
      ])

    assign(assigns, :class, class)
  end
end
