defmodule PrenixComponents.Icon do
  use Phoenix.Component
  import PrenixComponents.Helpers

  attr :name, :string, default: nil, doc: "Tabler icon name"
  attr :class, :string, default: nil
  attr :size, :string, default: "md", values: ~w(sm md lg custom)

  attr :color, :string,
    default: "current",
    values: ~w(current default primary secondary success warning danger)

  attr :rest, :global

  slot :inner_block, doc: "Custom icon"

  def icon(assigns) do
    assigns = set_assigns(assigns)

    ~H"""
    <%= if @name do %>
      <%= render_icon(assigns) %>
    <% else %>
      <%= render_custom_icon(assigns) %>
    <% end %>
    """
  end

  defp render_icon(assigns) do
    ~H"""
    <span class={[@name, @class]} {@rest} />
    """
  end

  defp render_custom_icon(assigns) do
    ~H"""
    <span class={@class} {@rest}>
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
        assigns.class
      ])

    assign(assigns, :class, class)
  end
end
