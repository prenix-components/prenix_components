defmodule PrenixComponents.Avatar do
  use Phoenix.Component
  import PrenixComponents.Helpers
  import PrenixComponents.Icon

  @classes %{
    base: %{
      "avatar" => "avatar",
      "avatar-img" => "avatar-img",
      "avatar-fallback" => "avatar-fallback",
      "avatar-icon" => "avatar-icon"
    },
    default: %{
      "avatar" => "avatar--default"
    },
    primary: %{
      "avatar" => "avatar--primary"
    },
    secondary: %{
      "avatar" => "avatar--secondary"
    },
    success: %{
      "avatar" => "avatar--success"
    },
    warning: %{
      "avatar" => "avatar--warning"
    },
    danger: %{
      "avatar" => "avatar--danger"
    },
    sm: %{
      "avatar" => "avatar--sm",
      "avatar-icon" => "avatar-icon--sm"
    },
    md: %{
      "avatar" => "avatar--md",
      "avatar-icon" => "avatar-icon--md"
    },
    lg: %{
      "avatar" => "avatar--lg",
      "avatar-icon" => "avatar-icon--lg"
    },
    radius_sm: %{
      "avatar" => "avatar--radius-sm"
    },
    radius_md: %{
      "avatar" => "avatar--radius-md"
    },
    radius_lg: %{
      "avatar" => "avatar--radius-lg"
    },
    radius_full: %{
      "avatar" => "avatar--radius-full"
    },
    bordered: %{
      "avatar" => "avatar--bordered"
    }
  }

  attr :color, :string,
    default: "default",
    values: ~w(default primary secondary success warning danger)

  attr :size, :string, default: "md", values: ~w(sm md lg)
  attr :radius, :string, default: "full", values: ~w(sm md lg full)

  attr :src, :string, default: nil
  attr :class, :string, default: nil
  attr :img_class, :string, default: nil
  attr :fallback_class, :string, default: nil
  attr :icon, :string, default: nil
  attr :icon_class, :string, default: nil
  attr :name, :string, default: nil
  attr :show_fallback, :boolean, default: false
  attr :bordered, :boolean, default: false

  def avatar(assigns) do
    assigns = set_assigns(assigns)

    ~H"""
    <span tabindex="-1" class={@class}>
      <img
        src={@src}
        class={@img_class}
        alt="avatar"
        data-js-loaded="true"
        onload="this.closest('.avatar').dataset.jsLoaded=true"
      />

      <%= if @show_fallback do %>
        <span class={@fallback_class}>
          <%= if @name do %>
            <%= @name %>
          <% else %>
            <.icon class={@icon_class} name={@avatar_icon} size="" />
          <% end %>
        </span>
      <% end %>
    </span>
    """
  end

  defp set_assigns(assigns) do
    classes =
      merge_classes([
        @classes[:base],
        @classes[String.to_atom(assigns.color)],
        if(assigns.bordered, do: @classes[:bordered], else: %{}),
        @classes[String.to_atom(assigns.size)],
        @classes[String.to_atom("radius_#{assigns.radius}")]
      ])

    assigns
    |> assign(
      :class,
      combine_class([
        classes["avatar"],
        assigns.class
      ])
    )
    |> assign(
      :img_class,
      combine_class([
        classes["avatar-img"],
        assigns.img_class
      ])
    )
    |> assign(
      :fallback_class,
      combine_class([
        classes["avatar-fallback"],
        assigns.fallback_class
      ])
    )
    |> assign(
      :icon_class,
      combine_class([
        classes["avatar-icon"],
        assigns.icon_class
      ])
    )
    |> assign(
      :avatar_icon,
      assigns.icon || Application.get_env(:prenix_components, :user_icon, "mdi-person")
    )
  end
end
