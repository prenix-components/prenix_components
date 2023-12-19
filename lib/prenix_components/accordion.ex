defmodule PrenixComponents.Accordion do
  use Phoenix.Component
  import PrenixComponents.Helpers
  import PrenixComponents.Icon
  import PrenixComponents.Divider

  attr :base_class, :string, default: nil
  attr :variant, :string, default: "light", values: ~w(light shadow bordered splitted)
  attr :expand_multiple, :boolean, default: false
  slot :inner_block

  def accordion(assigns) do
    assigns = set_assigns(assigns)

    ~H"""
    <div class={@base_class} data-accordion id={@id} data-expand-multiple={@expand_multiple}>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  attr :show, :boolean, default: false
  attr :base_class, :string, default: nil
  attr :toggle_class, :string, default: nil
  attr :toggle_content_class, :string, default: nil
  attr :toggle_caret_class, :string, default: nil
  attr :body_class, :string, default: nil
  attr :divider_class, :string, default: nil

  slot :toggle
  slot :inner_block

  def accordion_item(assigns) do
    assigns = set_accordion_item_assigns(assigns)

    ~H"""
    <div class={@base_class}>
      <button
        class={@toggle_class}
        data-bs-toggle="collapse"
        data-bs-target={"##{@id}"}
        aria-expanded={if(@show, do: "true", else: "false")}
        aria-controls={@id}
      >
        <span class={@toggle_content_class}>
          <%= render_slot(@toggle) %>
        </span>

        <.icon base_class={@toggle_caret_class} name="hero-chevron-left-mini" />
      </button>

      <div id={@id} class={@collapse_class} data-bs-parent="">
        <div class={@body_class}>
          <%= render_slot(@inner_block) %>
        </div>
      </div>

      <.divider base_class={@divider_class} />
    </div>
    """
  end

  defp set_assigns(assigns) do
    base_class =
      combine_class([
        "accordion-base",
        "accordion-#{assigns.variant}",
        "#{assigns.base_class}"
      ])

    assigns
    |> assign(:base_class, base_class)
    |> assign(:id, "accordion-#{random_string()}")
    |> assign(:expand_multiple, if(assigns.expand_multiple, do: "true", else: "false"))
  end

  defp set_accordion_item_assigns(assigns) do
    base_class =
      combine_class([
        "accordion-item",
        "#{assigns.base_class}"
      ])

    toggle_class =
      combine_class([
        "accordion-item-toggle",
        assigns.toggle_class
      ])

    toggle_content_class =
      combine_class([
        "accordion-item-toggle-content",
        assigns.toggle_content_class
      ])

    toggle_caret_class =
      combine_class([
        "accordion-item-toggle-caret",
        assigns.toggle_caret_class
      ])

    body_class =
      combine_class([
        "accordion-item-body",
        assigns.body_class
      ])

    collapse_class =
      combine_class([
        "accordion-collapse prenix-collapse collapse",
        if(assigns.show, do: "show", else: nil)
      ])

    divider_class =
      combine_class([
        "accordion-item-divider",
        assigns.divider_class
      ])

    assigns
    |> assign(:id, "accordion-item-#{random_string()}")
    |> assign(:base_class, base_class)
    |> assign(:toggle_class, toggle_class)
    |> assign(:toggle_content_class, toggle_content_class)
    |> assign(:toggle_caret_class, toggle_caret_class)
    |> assign(:body_class, body_class)
    |> assign(:collapse_class, collapse_class)
    |> assign(:divider_class, divider_class)
  end
end
