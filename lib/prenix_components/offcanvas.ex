defmodule PrenixComponents.Offcanvas do
  use Phoenix.Component
  import PrenixComponents.Helpers
  import PrenixComponents.Icon
  import PrenixComponents.Button

  @classes %{
    base: %{
      "offcanvas" => "offcanvas",
      "offcanvas-body" => "offcanvas-body",
      "offcanvas-close" => "offcanvas-close"
    },
    left: %{
      "offcanvas" => "offcanvas-start"
    },
    right: %{
      "offcanvas" => "offcanvas-end"
    },
    top: %{
      "offcanvas" => "offcanvas-top"
    },
    bottom: %{
      "offcanvas" => "offcanvas-bottom"
    }
  }

  attr :id, :string, required: true
  attr :name, :string, default: nil
  attr :class, :string, default: nil
  attr :body_class, :string, default: nil
  attr :close_button_class, :string, default: nil
  attr :placement, :string, default: "left", values: ~w(top bottom left right)
  slot :body
  slot :inner_block

  def offcanvas(assigns) do
    assigns = set_assigns(assigns)

    ~H"""
    <div class={@class} id={@id} tabindex="-1">
      <.button
        size="sm"
        icon
        radius="full"
        variant="light"
        class={@close_button_class}
        data-bs-dismiss="offcanvas"
        aria-label="Close"
      >
        <.icon name={@close_icon} />
      </.button>

      <%= if @body != [] do %>
        <div class={@body_class}><%= render_slot(@body) %></div>
      <% end %>

      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  defp set_assigns(assigns) do
    classes =
      merge_classes([
        @classes[:base],
        @classes[String.to_atom(assigns.placement)]
      ])

    assigns
    |> assign(
      :class,
      combine_class([
        classes["offcanvas"],
        assigns.class
      ])
    )
    |> assign(
      :body_class,
      combine_class([
        classes["offcanvas-body"],
        assigns.body_class
      ])
    )
    |> assign(
      :close_button_class,
      combine_class([
        classes["offcanvas-close"],
        assigns.close_button_class
      ])
    )
    |> assign(:close_icon, Application.get_env(:prenix_components, :close_icon, "mdi-close"))
  end

  attr :offcanvas_id, :string, required: true
  attr :class, :string, default: nil
  slot :inner_block, required: true

  def offcanvas_toggle(assigns) do
    ~H"""
    <div
      class={["offcanvas-toggle", @class]}
      data-bs-toggle="offcanvas"
      data-bs-target={"##{@offcanvas_id}"}
      aria-controls={@offcanvas_id}
    >
      <%= render_slot(@inner_block) %>
    </div>
    """
  end
end
