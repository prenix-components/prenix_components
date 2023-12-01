defmodule PrenixComponents.Dropdown do
  use Phoenix.Component
  import PrenixComponents.Helpers
  import PrenixComponents.Icon

  @variants [
    "solid",
    "soft"
  ]

  attr :class, :string, default: nil
  attr :toggle_class, :string, default: nil
  attr :menu_class, :string, default: nil
  attr :variant, :string, default: "solid", values: @variants
  slot :toggle, required: true
  slot :menu, required: true

  def dropdown(assigns) do
    assigns = set_assigns(assigns)

    ~H"""
    <div class={@class}>
      <div class={@toggle_class} id={@id}>
        <%= render_slot(@toggle) %>
      </div>

      <div class="hs-dropdown-menu dropdown-menu-wrapper">
        <div class={@menu_class} aria-labelledby={@id} data-hs-transition role="menu">
          <%= render_slot(@menu) %>
        </div>
      </div>
    </div>
    """
  end

  @colors [
    "default",
    "primary",
    "secondary",
    "success",
    "warning",
    "danger"
  ]

  attr :type, :string, default: "link", values: ["link", "button"]
  attr :color, :string, default: "default", values: @colors
  attr :class, :string, default: nil
  attr :disabled, :boolean, default: false
  attr :rest, :global
  slot :start_content
  slot :end_content
  slot :inner_block

  def dropdown_item(assigns) do
    class =
      combine_class([
        "dropdown-item group",
        "dropdown-item-#{assigns.color}",
        if(assigns.disabled, do: "dropdown-item-disabled disabled", else: nil),
        assigns.class
      ])

    assigns = assign(assigns, :class, class)

    ~H"""
    <%= if @type == "link" do %>
      <.link
        class={@class}
        role="menuitem"
        aria-disabled={@disabled}
        tabindex={if(@disabled, do: -1, else: false)}
        {@rest}
      >
        <%= render_slot(@start_content) %>

        <span class="flex-1 truncate text-left">
          <%= render_slot(@inner_block) %>
        </span>

        <%= render_slot(@end_content) %>
      </.link>
    <% else %>
      <button class={@class} role="menuitem" aria-disabled={@disabled} disabled={@disabled} {@rest}>
        <%= render_slot(@start_content) %>

        <span class="flex-1 truncate text-left">
          <%= render_slot(@inner_block) %>
        </span>

        <%= render_slot(@end_content) %>
      </button>
    <% end %>
    """
  end

  attr(:class, :string, default: nil, doc: "Additional CSS class")
  slot(:inner_block)

  def dropdown_rotate(assigns) do
    ~H"""
    <span class={["dropdown-rotate", @class]}>
      <%= if length(@inner_block) > 0 do %>
        <%= render_slot(@inner_block) %>
      <% else %>
        <.icon name="hero-chevron-down-mini" />
      <% end %>
    </span>
    """
  end

  attr(:class, :string, default: nil, doc: "Additional CSS class")

  def dropdown_divider(assigns) do
    ~H"""
    <hr class={["dropdown-divider", @class]} />
    """
  end

  defp set_assigns(assigns) do
    class =
      combine_class([
        "hs-dropdown dropdown [--auto-close:inside]",
        assigns.class,
        "dropdown-#{assigns.variant}"
      ])

    toggle_class =
      combine_class([
        "hs-dropdown-toggle dropdown-toggle",
        assigns.toggle_class
      ])

    menu_class =
      combine_class([
        "dropdown-menu",
        assigns.menu_class
      ])

    assigns
    |> assign(:id, "dropdown-#{random_string()}")
    |> assign(:class, class)
    |> assign(:toggle_class, toggle_class)
    |> assign(:menu_class, menu_class)
  end
end
