defmodule PrenixComponents.Button do
  use Phoenix.Component
  import PrenixComponents.Spinner
  import PrenixComponents.Helpers

  @types ["button", "submit", "reset", "link"]

  @sizes [
    "sm",
    "md",
    "lg"
  ]

  @colors [
    "default",
    "primary",
    "secondary",
    "success",
    "warning",
    "danger"
  ]

  @variants [
    "solid",
    "soft",
    "outline",
    "ghost"
  ]

  attr :type, :string, default: "button", values: @types
  attr :color, :string, default: "default", values: @colors
  attr :variant, :string, default: "solid", values: @variants
  attr :size, :string, default: "md", values: @sizes

  attr :icon, :boolean, default: false
  attr :rounded, :boolean, default: false
  attr :loading, :boolean, default: false
  attr :disabled, :boolean, default: false
  attr :class, :string, default: nil
  attr :rest, :global
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
        <span class="btn-content">
          <%= render_slot(@inner_block) %>
        </span>

        <span :if={@loading} class="btn-spinner">
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
        <span class="btn-content">
          <%= render_slot(@inner_block) %>
        </span>

        <span :if={@loading} class="btn-spinner">
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
        if(assigns.icon, do: "btn-icon", else: nil),
        if(assigns.rounded, do: "btn-rounded", else: nil),
        if(assigns.disabled, do: "btn-disabled", else: nil),
        if(assigns.loading, do: "btn-loading", else: nil),
        assigns.class
      ])

    assign(assigns, :class, class)
  end
end
