defmodule PrenixComponents.Icon do
  use Phoenix.Component
  import PrenixComponents.Helpers

  attr :name, :string, default: nil, doc: "Heroicon name"
  attr :base_class, :string, default: nil
  attr :size, :string, default: "md", values: ~w(sm md lg)

  attr :color, :string,
    default: "current",
    values: ~w(current default primary secondary success warning danger)

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
    <span class={[@name, @base_class]} />
    """
  end

  defp render_custom_icon(assigns) do
    ~H"""
    <span class={@base_class}>
      <%= render_slot(@inner_block) %>
    </span>
    """
  end

  defp set_assigns(assigns) do
    base_class =
      combine_class([
        "icon-base",
        "icon-#{assigns.color}",
        "icon-#{assigns.size}",
        "#{assigns.base_class}"
      ])

    assign(assigns, :base_class, base_class)
  end
end
