defmodule PrenixComponents.Avatar do
  use Phoenix.Component
  import PrenixComponents.Helpers
  import PrenixComponents.Icon

  attr :color, :string,
    default: "default",
    values: ~w(default primary secondary success warning danger)

  attr :size, :string, default: "md", values: ~w(sm md lg)
  attr :radius, :string, default: "full", values: ~w(sm md lg full)

  attr :src, :string, default: nil

  attr :class, :string, default: nil
  attr :img_class, :string, default: nil
  attr :fallback_class, :string, default: nil
  attr :fallback_icon, :string, default: nil
  attr :fallback_name, :string, default: nil
  attr :show_fallback, :boolean, default: false
  attr :bordered, :boolean, default: false

  def avatar(assigns) do
    assigns = set_assigns(assigns)

    ~H"""
    <span tabindex="-1" class={@class} data-avatar>
      <img src={@src} class={@img_class} alt="avatar" />

      <%= if @show_fallback do %>
        <span class={@fallback_class}>
          <%= if @fallback_name do %>
            <%= @fallback_name %>
          <% else %>
            <.icon name={@avatar_icon} />
          <% end %>
        </span>
      <% end %>
    </span>
    """
  end

  defp set_assigns(assigns) do
    class =
      combine_class([
        "avatar",
        "avatar-#{assigns.size}",
        "avatar-radius-#{assigns.radius}",
        if(assigns.bordered, do: "avatar-bordered", else: ""),
        "avatar-#{assigns.color}",
        assigns.class
      ])

    img_class =
      combine_class([
        "avatar-img",
        assigns.img_class
      ])

    fallback_class =
      combine_class([
        "avatar-fallback",
        assigns.fallback_class
      ])

    assigns
    |> assign(:class, class)
    |> assign(:img_class, img_class)
    |> assign(:fallback_class, fallback_class)
    |> assign(
      :avatar_icon,
      assigns.fallback_icon || Application.get_env(:prenix_components, :user_icon, "mdi-person")
    )
  end
end
