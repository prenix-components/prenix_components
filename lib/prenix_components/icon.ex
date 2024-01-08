defmodule PrenixComponents.Icon do
  use Phoenix.Component
  import PrenixComponents.Helpers

  @classes %{
    base: %{
      "icon" => "icon"
    },
    sm: %{
      "icon" => "icon--sm"
    },
    md: %{
      "icon" => "icon--md"
    },
    lg: %{
      "icon" => "icon--lg"
    },
    current: %{
      "icon" => "icon--current"
    },
    default: %{
      "icon" => "icon--default"
    },
    primary: %{
      "icon" => "icon--primary"
    },
    secondary: %{
      "icon" => "icon--secondary"
    },
    success: %{
      "icon" => "icon--success"
    },
    warning: %{
      "icon" => "icon--warning"
    },
    danger: %{
      "icon" => "icon--danger"
    }
  }

  attr :name, :string, default: nil, doc: "Tabler icon name"
  attr :class, :string, default: nil
  attr :size, :string, default: "md", values: ["sm", "md", "lg", ""]

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
    classes =
      merge_classes([
        @classes[:base],
        @classes[String.to_atom(assigns.color)],
        if(assigns.size != "", do: @classes[String.to_atom(assigns.size)], else: %{})
      ])

    assigns
    |> assign(
      :class,
      combine_class([
        classes["icon"],
        assigns.class
      ])
    )
  end
end
