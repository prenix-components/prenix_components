defmodule PrenixComponents.Modal do
  use Phoenix.Component
  import PrenixComponents.Helpers
  import PrenixComponents.Icon
  import PrenixComponents.Button

  @classes %{
    base: %{
      "modal" => "modal",
      "modal-header" => "modal-header",
      "modal-body" => "modal-body",
      "modal-footer" => "modal-footer",
      "modal-dialog" => "modal-dialog",
      "modal-content" => "modal-content",
      "modal-close" => "modal-close"
    },
    sm: %{
      "modal" => "modal--sm"
    },
    md: %{
      "modal" => "modal--md"
    },
    lg: %{
      "modal" => "modal--lg"
    },
    outside: %{
      "modal" => "modal--scroll-outside",
      "modal-content" => "modal-content--scroll-outside"
    },
    inside: %{
      "modal-body" => "modal-body--scroll-inside",
      "modal-dialog" => "modal-dialog--scroll-inside",
      "modal-content" => "modal-content--scroll-inside"
    }
  }

  @fullscreens [
    nil,
    "always",
    "2xl-below",
    "xl-below",
    "lg-below",
    "md-below",
    "sm-below"
  ]

  attr :id, :string, required: true
  attr :size, :string, default: "md", values: ~w(sm md lg)
  attr :scroll_behavior, :string, default: "outside", values: ~w(outside inside)
  attr :fullscreen, :string, default: nil, values: @fullscreens
  attr :class, :string, default: nil
  attr :dialog_class, :string, default: nil
  attr :content_class, :string, default: nil
  attr :close_button_class, :string, default: nil

  slot :header do
    attr :class, :string
  end

  slot :body do
    attr :class, :string
  end

  slot :footer do
    attr :class, :string
  end

  slot :inner_block

  def modal(assigns) do
    assigns = set_assigns(assigns)

    ~H"""
    <div class={@class} id={@id} tabindex="-1" aria-labelledby={"#{@id}-label"} aria-hidden="true">
      <div class={@dialog_class}>
        <div class={@content_class}>
          <.button
            size="sm"
            icon
            radius="full"
            variant="light"
            class={@close_button_class}
            data-bs-dismiss="modal"
          >
            <.icon name={@close_icon} />
          </.button>

          <%= for header <- @header do %>
            <div class={[@header_class, Map.get(header, :class)]}>
              <%= render_slot(header) %>
            </div>
          <% end %>

          <%= for body <- @body do %>
            <div class={[@body_class, Map.get(body, :class)]}>
              <%= render_slot(body) %>
            </div>
          <% end %>

          <%= render_slot(@inner_block) %>

          <%= for footer <- @footer do %>
            <div class={[@footer_class, Map.get(footer, :class)]}>
              <%= render_slot(footer) %>
            </div>
          <% end %>
        </div>
      </div>
    </div>
    """
  end

  def set_assigns(assigns) do
    classes =
      merge_classes([
        @classes[:base],
        @classes[String.to_atom(assigns.size)],
        @classes[String.to_atom(assigns.scroll_behavior)]
      ])

    assigns
    |> assign(
      :class,
      combine_class([
        classes["modal"],
        if(assigns.fullscreen, do: "modal--fullscreen-#{assigns.fullscreen}", else: nil),
        assigns.class
      ])
    )
    |> assign(
      :dialog_class,
      combine_class([
        classes["modal-dialog"],
        assigns.dialog_class
      ])
    )
    |> assign(
      :content_class,
      combine_class([
        classes["modal-content"],
        assigns.content_class
      ])
    )
    |> assign(
      :close_button_class,
      combine_class([
        classes["modal-close"],
        assigns.close_button_class
      ])
    )
    |> assign(:header_class, classes["modal-header"])
    |> assign(:body_class, classes["modal-body"])
    |> assign(:footer_class, classes["modal-footer"])
    |> assign(:close_icon, Application.get_env(:prenix_components, :close_icon, "mdi-close"))
  end
end
