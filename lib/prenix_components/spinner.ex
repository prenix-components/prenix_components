defmodule PrenixComponents.Spinner do
  use Phoenix.Component
  import PrenixComponents.Helpers

  @classes %{
    base: %{
      "spinner" => "spinner",
      "spinner-content" => "spinner-content"
    },
    sm: %{
      "spinner-content" => "spinner-content--sm"
    },
    md: %{
      "spinner-content" => "spinner-content--md"
    },
    lg: %{
      "spinner-content" => "spinner-content--lg"
    },
    current: %{
      "spinner" => "spinner--current"
    },
    default: %{
      "spinner" => "spinner--default"
    },
    primary: %{
      "spinner" => "spinner--primary"
    },
    secondary: %{
      "spinner" => "spinner--secondary"
    },
    success: %{
      "spinner" => "spinner--success"
    },
    warning: %{
      "spinner" => "spinner--warning"
    },
    danger: %{
      "spinner" => "spinner--danger"
    }
  }

  attr :class, :string, default: nil
  attr :content_class, :string, default: nil
  attr :size, :string, default: "md", values: ["sm", "md", "lg", ""]

  attr :color, :string,
    default: "current",
    values: ~w(current default primary secondary success warning danger)

  def spinner(assigns) do
    assigns = set_assigns(assigns)

    ~H"""
    <div aria-label="Loading" class={@class}>
      <div class={@content_class}>
        <span class="sr-only">Loading...</span>
        <i class="spinner-icon-solid" />
        <i class="spinner-icon-dotted" />
      </div>
    </div>
    """
  end

  defp set_assigns(assigns) do
    IO.inspect(assigns, label: "assign")

    classes =
      merge_classes([
        @classes[:base],
        @classes[String.to_atom(assigns.color)],
        if(assigns.size != "", do: @classes[String.to_atom(assigns.size)], else: %{})
      ])

    IO.inspect(classes, label: "classes")

    assigns
    |> assign(
      :class,
      combine_class([
        classes["spinner"],
        assigns.class
      ])
    )
    |> assign(
      :content_class,
      combine_class([
        classes["spinner-content"],
        assigns.content_class
      ])
    )
  end
end
