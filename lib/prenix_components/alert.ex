defmodule PrenixComponents.Alert do
  use Phoenix.Component
  import PrenixComponents.Helpers
  import PrenixComponents.Icon
  import PrenixComponents.Button

  @classes %{
    base: %{
      "alert" => "alert alert-dismissable",
      "alert-body" => "alert-body",
      "alert-close" => "alert-close"
    },
    default: %{
      "alert" => "alert--default"
    },
    primary: %{
      "alert" => "alert--primary"
    },
    secondary: %{
      "alert" => "alert--secondary"
    },
    success: %{
      "alert" => "alert--success"
    },
    warning: %{
      "alert" => "alert--warning"
    },
    danger: %{
      "alert" => "alert--danger"
    },
    solid: %{
      "alert" => "alert--solid"
    },
    flat: %{
      "alert" => "alert--flat"
    }
  }

  attr :color, :string,
    default: "default",
    values: ~w(default primary secondary success warning danger)

  attr :variant, :string, default: "flat", values: ~w(flat solid)
  attr :src, :string, default: nil
  attr :class, :string, default: nil
  attr :body_class, :string, default: nil
  attr :close_button_class, :string, default: nil
  attr :dismissable, :boolean, default: true
  slot :inner_block

  def alert(assigns) do
    assigns = set_assigns(assigns)

    ~H"""
    <div class={@class} role="alert">
      <div class={@body_class}>
        <%= render_slot(@inner_block) %>
      </div>

      <%= if @dismissable do %>
        <.button
          size="sm"
          icon
          radius="full"
          variant="light"
          class={@close_button_class}
          data-bs-dismiss="alert"
          aria-label="Close"
        >
          <.icon name={@close_icon} />
        </.button>
      <% end %>
    </div>
    """
  end

  defp set_assigns(assigns) do
    classes =
      merge_classes([
        @classes[:base],
        @classes[String.to_atom(assigns.color)],
        @classes[String.to_atom(assigns.variant)]
      ])

    assigns
    |> assign(
      :class,
      combine_class([
        classes["alert"],
        assigns.class
      ])
    )
    |> assign(
      :body_class,
      combine_class([
        classes["alert-body"],
        assigns.body_class
      ])
    )
    |> assign(
      :close_button_class,
      combine_class([
        classes["alert-close"],
        assigns.close_button_class
      ])
    )
    |> assign(:close_icon, Application.get_env(:prenix_components, :close_icon, "mdi-close"))
  end
end
