defmodule PrenixComponents.Dropdown do
  use Phoenix.Component
  import PrenixComponents.Helpers
  import PrenixComponents.Icon
  import PrenixComponents.Divider

  @placements %{
    "dropdown" => "dropdown",
    "dropdown-center" => "dropdown-center",
    "dropup" => "dropup",
    "dropup-center" => "dropup-center dropup ",
    "dropend" => "dropend",
    "dropstart" => "dropstart"
  }

  @offsets %{
    "dropdown" => "0, 8",
    "dropdown-center" => "0, 8",
    "dropup" => "0, 8",
    "dropup-center" => "0, 8",
    "dropend" => "8, 0",
    "dropstart" => "8, 0"
  }

  attr :class, :string, default: nil
  attr :toggle_class, :string, default: nil
  attr :content_class, :string, default: nil
  attr :submenu, :boolean, default: false
  attr :variant, :string, default: "solid", values: ~w(solid flat)
  attr :auto_close, :string, default: "outside", values: ~w(true inside outside false)
  attr :placement, :string, default: "dropdown", values: Map.keys(@placements)
  attr :offset, :string, default: nil
  slot :toggle, required: true
  slot :inner_block

  def dropdown(%{submenu: true} = assigns) do
    assigns = set_assigns(assigns)

    ~H"""
    <div class={@class}>
      <div
        class={@toggle_class}
        data-bs-toggle="collapse"
        data-bs-target={"##{@submenu_id}"}
        aria-expanded="false"
        aria-controls={@submenu_id}
      >
        <%= render_slot(@toggle) %>
      </div>

      <div class={@content_class} id={@submenu_id}>
        <%= render_slot(@inner_block) %>
      </div>
    </div>
    """
  end

  def dropdown(assigns) do
    assigns = set_assigns(assigns)

    ~H"""
    <div class={@class} data-dropdown>
      <div
        class={@toggle_class}
        data-bs-toggle="dropdown"
        aria-expanded="false"
        data-bs-offset={@offset}
        data-bs-auto-close={@auto_close}
      >
        <%= render_slot(@toggle) %>
      </div>

      <div class="dropdown-menu">
        <div class={@content_class}>
          <%= render_slot(@inner_block) %>
        </div>
      </div>
    </div>
    """
  end

  attr :type, :string, default: "button", values: ~w(link button)

  attr :color, :string,
    default: "default",
    values: ~w(default primary secondary success warning danger)

  attr :submenu_toggle, :boolean, default: false
  attr :class, :string, default: nil
  attr :disabled, :boolean, default: false
  attr :rest, :global, include: ~w(href)
  slot :start_content
  slot :end_content
  slot :inner_block

  def dropdown_item(assigns) do
    assigns = set_dropdown_item_assigns(assigns)

    ~H"""
    <%= if @type == "link" do %>
      <.link
        class={@class}
        role="menuitem"
        aria-disabled={@disabled}
        tabindex={if(@disabled, do: -1, else: false)}
        data-hover="false"
        {@rest}
      >
        <%= render_dropdown_item(assigns) %>

        <%= if @submenu_toggle do %>
          <span class="dropdown-submenu-item-icon">
            <.icon name={@chevron_right_icon} size="sm" />
          </span>
        <% end %>
      </.link>
    <% else %>
      <button
        class={@class}
        role="menuitem"
        aria-disabled={@disabled}
        disabled={@disabled}
        type="button"
        data-hover="false"
        {@rest}
      >
        <%= render_dropdown_item(assigns) %>

        <%= if @submenu_toggle do %>
          <span class="dropdown-submenu-item-icon">
            <.icon name={@chevron_right_icon} size="sm" />
          </span>
        <% end %>
      </button>
    <% end %>
    """
  end

  attr :class, :string, default: nil
  slot :inner_block

  def dropdown_rotate(assigns) do
    assigns =
      assign(
        assigns,
        :chevron_down_icon,
        Application.get_env(:prenix_components, :chevron_down_icon, "ion-chevron-down")
      )

    ~H"""
    <span class={["dropdown-rotate", @class]}>
      <%= if length(@inner_block) > 0 do %>
        <%= render_slot(@inner_block) %>
      <% else %>
        <.icon name={@chevron_down_icon} size="sm" />
      <% end %>
    </span>
    """
  end

  attr :class, :string, default: nil

  def dropdown_divider(assigns) do
    ~H"""
    <div class={["dropdown-divider", @class]}>
      <.divider />
    </div>
    """
  end

  defp set_assigns(assigns) do
    class =
      combine_class([
        "dropdown #{@placements[assigns.placement]}",
        "dropdown-#{assigns.variant}",
        if(assigns.submenu, do: "dropend dropdown-submenu", else: nil),
        assigns.class
      ])

    toggle_class =
      combine_class([
        "dropdown-toggle",
        assigns.toggle_class
      ])

    content_class =
      combine_class([
        if(assigns.submenu,
          do: "collapse prenix-collapse dropdown-submenu-content",
          else: "dropdown-content"
        ),
        assigns.content_class
      ])

    offset =
      cond do
        assigns.offset -> assigns.offset
        assigns.submenu -> "4, 4"
        @offsets[assigns.offset] -> @offsets[assigns.offset]
        true -> "0, 8"
      end

    assigns
    |> assign(:class, class)
    |> assign(:toggle_class, toggle_class)
    |> assign(:content_class, content_class)
    |> assign(:offset, offset)
    |> assign(:submenu_id, "dropdown-submenu-#{random_string()}")
  end

  defp set_dropdown_item_assigns(assigns) do
    class =
      combine_class([
        "dropdown-item group",
        "dropdown-item-#{assigns.color}",
        if(assigns.disabled, do: "dropdown-item-disabled disabled", else: nil),
        if(assigns.type == "submenu", do: "dropdown-item-submenu", else: nil),
        assigns.class
      ])

    assigns
    |> assign(:class, class)
    |> assign(
      :chevron_right_icon,
      Application.get_env(:prenix_components, :chevron_right_icon, "ion-chevron-forward")
    )
  end

  defp render_dropdown_item(assigns) do
    ~H"""
    <%= render_slot(@start_content) %>

    <div class="flex-1 truncate text-left">
      <%= render_slot(@inner_block) %>
    </div>

    <%= render_slot(@end_content) %>
    """
  end
end
