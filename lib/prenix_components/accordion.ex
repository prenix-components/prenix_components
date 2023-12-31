defmodule PrenixComponents.Accordion do
  use Phoenix.Component
  import PrenixComponents.Helpers

  @classes %{
    base: %{
      "accordion" => "js-accordion",
      "accordion-item" => "js-accordion-item",
      "accordion-item-toggle" => "js-accordion-item-toggle",
      "accordion-item-icon-wrapper" => "js-accordion-item-icon-wrapper",
      "accordion-item-icon" => "js-accordion-item-icon",
      "accordion-item-body" => "js-accordion-item-body",
      "accordion-item-divider" => "js-accordion-item-divider"
    },
    light: %{
      "accordion" => "js-accordion--light"
    },
    shadow: %{
      "accordion" => "js-accordion--shadow"
    },
    bordered: %{
      "accordion" => "js-accordion--bordered"
    },
    splitted: %{
      "accordion" => "js-accordion--splitted",
      "accordion-item" => "js-accordion-item--splitted",
      "accordion-item-divider" => "js-accordion-item-divider--splitted"
    }
  }

  attr :class, :string, default: nil
  attr :variant, :string, default: "light", values: ~w(light shadow bordered splitted)
  attr :expand_multiple, :boolean, default: false
  slot :inner_block

  def accordion(assigns) do
    assigns = set_assigns(assigns)

    ~H"""
    <div
      class={@class}
      data-accordion
      id={@id}
      data-expand-multiple={@expand_multiple}
      data-classes={@classes}
    >
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  defp set_assigns(assigns) do
    # Classes are added via Javascript because Phoenix doesn't support nested slots :)
    data_classes =
      Jason.encode!(merge_classes([@classes[:base], @classes[String.to_atom(assigns.variant)]]))

    assigns
    |> assign(:class, assigns.class)
    |> assign(:id, "accordion-#{random_string()}")
    |> assign(:expand_multiple, if(assigns.expand_multiple, do: "true", else: "false"))
    |> assign(:classes, data_classes)
  end
end
