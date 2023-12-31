defmodule PrenixComponents.Badge do
  use Phoenix.Component
  import PrenixComponents.Helpers
  import PrenixComponents.Divider

  attr :class, :string, default: nil
  attr :content_text, :string, default: nil
  attr :content_class, :string, default: nil

  attr :color, :string,
    default: "default",
    values: ~w(default primary secondary success warning danger)

  attr :size, :string, default: "md", values: ~w(sm md lg)

  attr :placement, :string,
    default: "top-right",
    values: ~w(top-left top-right bottom-left bottom-right)

  slot :content
  slot :inner_block

  def badge(assigns) do
    assigns = set_assigns(assigns)

    ~H"""
    <div class={@class} data-badge>
      <%= render_slot(@inner_block) %>

      <%= if @content_text do %>
        <span class={@content_class}>
          <%= @content_text %>
        </span>
      <% end %>

      <%= if @content != [] do %>
        <span class={@content_class}>
          <%= render_slot(@content) %>
        </span>
      <% end %>
    </div>
    """
  end

  defp set_assigns(assigns) do
    class =
      combine_class([
        "badge",
        "badge-#{assigns.placement}",
        "badge-#{assigns.color}",
        "badge-#{assigns.size}",
        "#{assigns.class}"
      ])

    content_class =
      combine_class([
        "badge-content",
        "#{assigns.content_class}"
      ])

    assigns
    |> assign(:class, class)
    |> assign(:content_class, content_class)
  end
end
