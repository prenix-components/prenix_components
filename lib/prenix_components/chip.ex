defmodule PrenixComponents.Chip do
  use Phoenix.Component
  import PrenixComponents.Helpers

  @classes %{
    base: %{
      "chip" => "chip",
      "chip-content" => "chip-content"
    },
    solid: %{
      "chip" => "chip--solid"
    },
    flat: %{
      "chip" => "chip--flat"
    },
    bordered: %{
      "chip" => "chip--bordered"
    },
    sm: %{
      "chip" => "chip--sm",
      "chip-content" => "chip-content--sm"
    },
    md: %{
      "chip" => "chip--md",
      "chip-content" => "chip-content--md"
    },
    lg: %{
      "chip" => "chip--lg",
      "chip-content" => "chip-content--lg"
    },
    radius_sm: %{
      "chip" => "chip--radius-sm"
    },
    radius_md: %{
      "chip" => "chip--radius-md"
    },
    radius_lg: %{
      "chip" => "chip--radius-lg"
    },
    radius_full: %{
      "chip" => "chip--radius-full"
    },
    default: %{
      "chip" => "chip--default"
    },
    primary: %{
      "chip" => "chip--primary"
    },
    secondary: %{
      "chip" => "chip--secondary"
    },
    success: %{
      "chip" => "chip--success"
    },
    warning: %{
      "chip" => "chip--warning"
    },
    danger: %{
      "chip" => "chip--danger"
    }
  }

  attr :class, :string, default: nil
  attr :content_class, :string, default: nil

  attr :color, :string,
    default: "default",
    values: ~w(default primary secondary success warning danger)

  attr :variant, :string, default: "solid", values: ~w(solid flat bordered)
  attr :radius, :string, default: "full", values: ~w(sm md lg full)
  attr :size, :string, default: "md", values: ~w(sm md lg)
  attr :rest, :global
  slot :inner_block

  def chip(assigns) do
    assigns = set_assigns(assigns)

    ~H"""
    <div class={@class} {@rest}>
      <span class={@content_class}>
        <%= render_slot(@inner_block) %>
      </span>
    </div>
    """
  end

  defp set_assigns(assigns) do
    classes =
      merge_classes([
        @classes[:base],
        @classes[String.to_atom(assigns.size)],
        @classes[String.to_atom(assigns.color)],
        @classes[String.to_atom(assigns.variant)],
        @classes[String.to_atom("radius_#{assigns.radius}")]
      ])

    assigns
    |> assign(
      :class,
      combine_class([
        classes["chip"],
        assigns.class
      ])
    )
    |> assign(
      :content_class,
      combine_class([
        classes["chip-content"],
        assigns.content_class
      ])
    )
  end
end
