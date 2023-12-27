defmodule PrenixComponents.Button do
  use Phoenix.Component
  import PrenixComponents.Spinner
  import PrenixComponents.Helpers

  attr :type, :string, default: "button", values: ~w(button submit reset link)

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
  attr :spinner_class, :string, default: nil
  attr :rest, :global, include: ~w(href)
  slot :inner_block

  def button(assigns) do
    assigns = set_assigns(assigns)

    ~H"""
    <%= if @type == "link" do %>
      <.link
        class={@class}
        aria-disabled={@disabled || @loading}
        tabindex={if(@disabled || @loading, do: -1, else: false)}
        {@rest}
      >
        <span class={@content_class}>
          <%= render_slot(@inner_block) %>
        </span>

        <span :if={@loading} class={@spinner_class}>
          <.spinner size="sm" />
        </span>
      </.link>
    <% else %>
      <button
        class={@class}
        type={@type}
        disabled={@disabled || @loading}
        aria-disabled={@disabled || @loading}
        {@rest}
      >
        <span class={@content_class}>
          <%= render_slot(@inner_block) %>
        </span>

        <span :if={@loading} class={@spinner_class}>
          <.spinner size="sm" />
        </span>
      </button>
    <% end %>
    """
  end

  defp set_assigns(assigns) do
    class =
      combine_class([
        "btn btn-ripple",
        "btn-#{assigns.color}",
        "btn-#{assigns.variant}",
        "btn-#{assigns.size}",
        "btn-radius-#{assigns.radius}",
        if(assigns.icon, do: "btn-icon", else: nil),
        if(assigns.disabled, do: "btn-disabled", else: nil),
        if(assigns.loading, do: "btn-loading", else: nil),
        assigns.class
      ])

    content_class =
      combine_class([
        "btn-content",
        assigns.content_class
      ])

    spinner_class =
      combine_class([
        "btn-spinner",
        assigns.spinner_class
      ])

    assigns
    |> assign(:class, class)
    |> assign(:content_class, content_class)
    |> assign(:spinner_class, spinner_class)
  end
end
