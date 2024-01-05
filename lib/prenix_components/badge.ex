defmodule PrenixComponents.Badge do
  use Phoenix.Component
  import PrenixComponents.Helpers

  @classes %{
    base: %{
      "badge" => "badge",
      "badge-content" => "badge-content"
    },
    default: %{
      "badge-content" => "badge-content--default"
    },
    primary: %{
      "badge-content" => "badge-content--primary"
    },
    secondary: %{
      "badge-content" => "badge-content--secondary"
    },
    success: %{
      "badge-content" => "badge-content--success"
    },
    warning: %{
      "badge-content" => "badge-content--warning"
    },
    danger: %{
      "badge-content" => "badge-content--danger"
    },
    "top-left": %{
      "badge-content" => "badge-content--top-left"
    },
    "top-right": %{
      "badge-content" => "badge-content--top-right"
    },
    "bottom-left": %{
      "badge-content" => "badge-content--bottom-left"
    },
    "bottom-right": %{
      "badge-content" => "badge-content--bottom-right"
    },
    dot: %{
      "badge-content" => "badge-content--dot"
    },
    "with-content": %{
      "badge-content" => "badge-content--with-content"
    },
    rectangle: %{
      "badge-content" => "badge-content--rectangle"
    },
    circle: %{
      "badge-content" => "badge-content--circle"
    }
  }

  attr :class, :string, default: nil
  attr :content_text, :string, default: nil
  attr :content_class, :string, default: nil
  attr :shape, :string, default: "rectangle", values: ~w(rectangle circle)

  attr :color, :string,
    default: "default",
    values: ~w(default primary secondary success warning danger)

  attr :dot, :boolean, default: false

  attr :variant, :string, default: "with-content", values: ~w(with-content dot)

  attr :placement, :string,
    default: "top-right",
    values: ~w(top-left top-right bottom-left bottom-right)

  slot :content
  slot :inner_block

  def badge(assigns) do
    assigns = set_assigns(assigns)

    ~H"""
    <div class={@class}>
      <%= render_slot(@inner_block) %>

      <%= if @variant == "dot" do %>
        <span class={@content_class}></span>
      <% else %>
        <%= render_content(assigns) %>
      <% end %>
    </div>
    """
  end

  defp render_content(assigns) do
    ~H"""
    <%= if @content_text do %>
      <span class={@content_class}>
        <%= @content_text %>
      </span>
    <% end %>

    <%= if @content != [] do %>
      <span class={@content_class}>
        <%= render_slot(@content) %>
      </span>
    <% end %>
    """
  end

  defp set_assigns(assigns) do
    classes =
      merge_classes([
        @classes[:base],
        @classes[String.to_atom(assigns.color)],
        @classes[String.to_atom(assigns.shape)],
        @classes[String.to_atom(assigns.placement)],
        @classes[String.to_atom(assigns.variant)]
      ])

    assigns
    |> assign(
      :class,
      combine_class([
        classes["badge"],
        assigns.class
      ])
    )
    |> assign(
      :content_class,
      combine_class([
        classes["badge-content"],
        assigns.content_class
      ])
    )
  end
end
