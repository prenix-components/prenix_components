defmodule PrenixComponents.Toast do
  use Phoenix.Component
  import PrenixComponents.Helpers
  import PrenixComponents.Icon
  import PrenixComponents.Button

  @classes %{
    base: %{
      "toast" => "toast",
      "toast-body" => "toast-body",
      "toast-close" => "toast-close"
    },
    default: %{
      "toast" => "toast--default"
    },
    primary: %{
      "toast" => "toast--primary"
    },
    secondary: %{
      "toast" => "toast--secondary"
    },
    success: %{
      "toast" => "toast--success"
    },
    warning: %{
      "toast" => "toast--warning"
    },
    danger: %{
      "toast" => "toast--danger"
    },
    solid: %{
      "toast" => "toast--solid"
    },
    flat: %{
      "toast" => "toast--flat"
    }
  }

  attr :color, :string,
    default: "default",
    values: ~w(default primary secondary success warning danger)

  attr :variant, :string, default: "flat", values: ~w(flat solid)

  attr :placement, :string,
    default: "top-right",
    values: ["top-right", "top-left", "bottom-right", "bottom-left"]

  attr :src, :string, default: nil
  attr :class, :string, default: nil
  attr :body_class, :string, default: nil
  attr :close_button_class, :string, default: nil
  attr :dismissable, :boolean, default: true
  attr :auto_dismiss, :boolean, default: true
  attr :auto_dismiss_duration, :integer, default: 10000
  attr :rest, :global
  slot :inner_block

  def toast(assigns) do
    assigns = set_assigns(assigns)

    ~H"""
    <div
      class={@class}
      {@rest}
      role="alert"
      data-toast
      data-auto-dismiss={@auto_dismiss}
      data-auto-dismiss-duration={@auto_dismiss_duration}
      data-placement={@placement}
    >
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
          data-bs-dismiss="toast"
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
        classes["toast"],
        assigns.class
      ])
    )
    |> assign(
      :body_class,
      combine_class([
        classes["toast-body"],
        assigns.body_class
      ])
    )
    |> assign(
      :close_button_class,
      combine_class([
        classes["toast-close"],
        assigns.close_button_class
      ])
    )
    |> assign(:close_icon, Application.get_env(:prenix_components, :close_icon, "mdi-close"))
  end
end
