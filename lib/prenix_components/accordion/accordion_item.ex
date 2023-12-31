defmodule PrenixComponents.Accordion.AccordionItem do
  use Phoenix.Component
  import PrenixComponents.Helpers
  import PrenixComponents.Icon
  import PrenixComponents.Divider

  attr :show, :boolean, default: false
  attr :class, :string, default: nil
  attr :body_class, :string, default: nil
  attr :divider_class, :string, default: nil

  slot :toggle do
    attr :class, :string
    attr :icon_wrapper_class, :string
    attr :icon_class, :string
  end

  slot :inner_block

  def accordion_item(assigns) do
    assigns = set_accordion_item_assigns(assigns)

    ~H"""
    <div class={@class} data-accordion-item>
      <%= for toggle <- @toggle do %>
        <button
          class={Map.get(toggle, :class)}
          data-accordion-item-toggle
          data-bs-toggle="collapse"
          data-bs-target={"##{@id}"}
          aria-expanded={if(@show, do: "true", else: "false")}
          aria-controls={@id}
        >
          <%= render_slot(toggle) %>

          <span class={Map.get(toggle, :icon_wrapper_class)} data-accordion-item-icon-wrapper>
            <.icon
              class={Map.get(toggle, :icon_class)}
              data-accordion-item-icon
              name={@chevron_left_icon}
            />
          </span>
        </button>
      <% end %>

      <div id={@id} class={@collapse_class} data-bs-parent="" data-accordion-collapse>
        <div class={@body_class} data-accordion-item-body>
          <%= render_slot(@inner_block) %>
        </div>
      </div>

      <.divider class={@divider_class} data-accordion-item-divider />
    </div>
    """
  end

  defp set_accordion_item_assigns(assigns) do
    collapse_class =
      combine_class([
        "prenix-collapse collapse",
        if(assigns.show, do: "show", else: nil)
      ])

    assigns
    |> assign(:id, "accordion-item-#{random_string()}")
    |> assign(:collapse_class, collapse_class)
    |> assign(
      :chevron_left_icon,
      Application.get_env(:prenix_components, :chevron_left_icon, "mdi-chevron-left")
    )
  end
end
