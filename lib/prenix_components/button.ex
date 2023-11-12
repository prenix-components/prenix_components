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

  @variants [
    "primary",
    "secondary",
    "success",
    "error",
    "warning",
    "neutral"
  ]

  attr(:type, :string, default: "button", values: @types)

  attr(:variant, :string,
    default: "primary",
    values: @variants
  )

  attr(:size, :string,
    default: "md",
    values: @sizes
  )

  attr(:outline, :boolean, default: false, doc: "Indicates outline variant")
  attr(:ghost, :boolean, default: false, doc: "Indicates ghost variant")
  attr(:soft, :boolean, default: false, doc: "Indicates soft variant")
  attr(:icon, :boolean, default: false, doc: "Indicates icon button")
  attr(:rounded, :boolean, default: false, doc: "Indicates rounded button")
  attr(:loading, :boolean, default: false, doc: "Indicates loading button")
  attr(:disabled, :boolean, default: false, doc: "Indicates disabled button")
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block)

  def button(assigns) do
    assigns = assign(assigns, :class, class(assigns))

    ~H"""
    <%= if @type == "link" do %>
      <.link class={@class} aria-disabled={@disabled || @loading}
      tabindex={if(@disabled || @loading, do: -1, else: false)}
      {@rest}>
        <span class="btn-inner">
          <%= render_slot(@inner_block) %>
        </span>

        <span :if={@loading} class="btn-spinner">
          <.spinner />
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
        <span class="btn-inner">
          <%= render_slot(@inner_block) %>
        </span>

        <span :if={@loading} class="btn-spinner">
          <.spinner />
        </span>
      </button>
    <% end %>
    """
  end

  defp class(assigns) do
    combine_class([
      "btn",
      "btn-#{assigns.size}",
      "btn-#{assigns.variant}",
      if(assigns.soft, do: "btn-soft", else: nil),
      if(assigns.outline, do: "btn-outline", else: nil),
      if(assigns.ghost, do: "btn-ghost", else: nil),
      if(assigns.icon, do: "btn-icon", else: nil),
      if(assigns.rounded, do: "btn-rounded", else: nil),
      if(assigns.loading, do: "btn-loading", else: nil),
      if(assigns.disabled, do: "btn-disabled", else: nil),
      assigns.class
    ])
  end
end
