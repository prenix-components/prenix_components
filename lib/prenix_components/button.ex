defmodule PrenixComponents.Button do
  use Phoenix.Component
  import PrenixComponents.Spinner
  import PrenixComponents.Helpers

  @classes %{
    base: %{
      "button" => "button",
      "button-content" => "button-content",
      "button-spinner-wrapper" => "button-spinner-wrapper"
    },
    solid: %{
      "button" => "button--solid"
    },
    flat: %{
      "button" => "button--flat"
    },
    bordered: %{
      "button" => "button--bordered"
    },
    light: %{
      "button" => "button--light"
    },
    sm: %{
      "button" => "button--sm",
      "button-content" => "button-content--sm"
    },
    md: %{
      "button" => "button--md",
      "button-content" => "button-content--md"
    },
    lg: %{
      "button" => "button--lg",
      "button-content" => "button-content--lg"
    },
    default: %{
      "button" => "button--default"
    },
    primary: %{
      "button" => "button--primary"
    },
    secondary: %{
      "button" => "button--secondary"
    },
    success: %{
      "button" => "button--success"
    },
    warning: %{
      "button" => "button--warning"
    },
    danger: %{
      "button" => "button--danger"
    },
    radius_sm: %{
      "button" => "button--radius-sm"
    },
    radius_md: %{
      "button" => "button--radius-md"
    },
    radius_lg: %{
      "button" => "button--radius-lg"
    },
    radius_full: %{
      "button" => "button--radius-full"
    },
    disabled: %{
      "button" => "button--disabled"
    },
    loading: %{
      "button" => "button--loading",
      "button-content" => "button-content--loading"
    },
    icon: %{
      "button" => "button--icon"
    },
    icon_sm: %{
      "button" => "button--icon-sm"
    },
    icon_md: %{
      "button" => "button--icon-md"
    },
    icon_lg: %{
      "button" => "button--icon-lg"
    }
  }

  attr :type, :string, default: nil, values: ["button", "submit", "reset", "link", nil]

  attr :color, :string,
    default: "default",
    values: ~w(default primary secondary success warning danger)

  attr :variant, :string, default: "solid", values: ~w(solid flat bordered light)
  attr :size, :string, default: "md", values: ~w(sm md lg)
  attr :icon, :boolean, default: false
  attr :radius, :string, default: "lg", values: ~w(sm md lg full)
  attr :loading, :boolean, default: false
  attr :disabled, :boolean, default: false
  attr :class, :string, default: nil
  attr :content_class, :string, default: nil
  attr :spinner_wrapper_class, :string, default: nil
  attr :spinner_class, :string, default: nil
  attr :link_type, :string, default: nil
  attr :rest, :global, include: ~w(href method download hreflang referrerpolicy rel target)
  slot :inner_block

  def button(assigns) do
    assigns = set_assigns(assigns)

    ~H"""
    <%= if @type == "link" do %>
      <.link
        data-ripple
        class={@class}
        aria-disabled={@disabled || @loading}
        tabindex={if(@disabled || @loading, do: -1, else: false)}
        type={@link_type}
        {@rest}
      >
        <span class={@content_class}>
          <%= render_slot(@inner_block) %>
        </span>

        <span :if={@loading} class={@spinner_wrapper_class}>
          <.spinner size="sm" class={@spinner_class} />
        </span>
      </.link>
    <% else %>
      <button
        data-ripple
        class={@class}
        type={@type}
        disabled={@disabled || @loading}
        aria-disabled={@disabled || @loading}
        {@rest}
      >
        <span class={@content_class}>
          <%= render_slot(@inner_block) %>
        </span>

        <span :if={@loading} class={@spinner_wrapper_class}>
          <.spinner size="sm" class={@spinner_class} />
        </span>
      </button>
    <% end %>
    """
  end

  defp set_assigns(assigns) do
    classes =
      merge_classes([
        @classes[:base],
        @classes[String.to_atom(assigns.color)],
        if(assigns.icon,
          do: @classes[String.to_atom("icon_#{assigns.size}")],
          else: @classes[String.to_atom(assigns.size)]
        ),
        @classes[String.to_atom(assigns.variant)],
        @classes[String.to_atom("radius_#{assigns.radius}")],
        if(assigns.disabled, do: @classes[:disabled], else: %{}),
        if(assigns.loading, do: @classes[:loading], else: %{}),
        if(assigns.icon, do: @classes[:icon], else: %{})
      ])

    assigns
    |> assign(
      :class,
      combine_class([
        classes["button"],
        assigns.class
      ])
    )
    |> assign(
      :content_class,
      combine_class([
        classes["button-content"],
        assigns.content_class
      ])
    )
    |> assign(
      :spinner_wrapper_class,
      combine_class([
        classes["button-spinner-wrapper"],
        assigns.spinner_wrapper_class
      ])
    )
  end
end
