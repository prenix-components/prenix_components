defmodule PrenixComponents.Link do
  use Phoenix.Component
  import PrenixComponents.Helpers
  import PrenixComponents.Icon

  attr :color, :string,
    default: "primary",
    values: ~w(current default primary secondary success warning danger)

  attr :size, :string, default: "inherit", values: ~w(sm md lg inherit)

  attr :underline, :string, default: "none", values: ~w(none hover always active focus)
  attr :class, :string, default: nil
  attr :external, :boolean, default: false
  attr :external_icon, :boolean, default: true
  attr :disabled, :boolean, default: false
  attr :navigate, :string, default: nil
  attr :patch, :string, default: nil
  attr :href, :any, default: nil
  attr :replace, :boolean, default: false
  attr :method, :string, default: "get"
  attr :csrf_token, :any, default: true
  attr :rest, :global, include: ~w(download hreflang referrerpolicy rel target type)
  slot :inner_block

  def link_for(assigns) do
    assigns = set_assigns(assigns)

    ~H"""
    <.link
      class={@class}
      navigate={@navigate}
      patch={@patch}
      href={@href}
      replace={@replace}
      method={@method}
      csrf_token={@csrf_token}
      aria-disabled={@disabled}
      tabindex={if(@disabled, do: -1, else: nil)}
      rel={if(@external, do: "noopener noreferrer", else: nil)}
      target={if(@external, do: "_blank", else: nil)}
      {@rest}
    >
      <%= render_slot(@inner_block) %>

      <%= if @external && @external_icon do %>
        <.icon name={@external_link_icon} />
      <% end %>
    </.link>
    """
  end

  defp set_assigns(assigns) do
    class =
      combine_class([
        "link",
        "link-#{assigns.color}",
        "link-#{assigns.size}",
        "link-underline-#{assigns.underline}",
        if(assigns.disabled, do: "link-disabled", else: nil),
        assigns.class
      ])

    assigns
    |> assign(:class, class)
    |> assign(
      :external_link_icon,
      Application.get_env(:prenix_components, :external_link_icon, "mdi-open-in-new")
    )
  end
end
