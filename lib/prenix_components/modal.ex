defmodule PrenixComponents.Modal do
  use Phoenix.Component
  import PrenixComponents.Helpers
  import PrenixComponents.Icon
  import PrenixComponents.Button

  @scroll_behaviors [
    nil,
    "inside"
  ]

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
  attr :scroll_behavior, :string, default: nil, values: @scroll_behaviors
  attr :fullscreen, :string, default: nil, values: @fullscreens
  attr :class, :string, default: nil
  attr :dialog_class, :string, default: nil
  attr :content_class, :string, default: nil
  attr :header_class, :string, default: nil
  attr :body_class, :string, default: nil
  attr :footer_class, :string, default: nil
  slot :header
  slot :body
  slot :footer

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
            variant="ghost"
            class="modal-close"
            data-bs-dismiss="modal"
          >
            <.icon name="ion-close" />
          </.button>

          <%= if length(@header) > 0 do %>
            <div class={@header_class} id={"#{@id}-label"}>
              <%= render_slot(@header) %>
            </div>
          <% end %>

          <%= if length(@body) > 0 do %>
            <div class={@body_class}>
              <%= render_slot(@body) %>
            </div>
          <% end %>

          <%= if length(@footer) > 0 do %>
            <div class={@footer_class}>
              <%= render_slot(@footer) %>
            </div>
          <% end %>
        </div>
      </div>
    </div>
    """
  end

  def set_assigns(assigns) do
    class =
      combine_class([
        "modal",
        "modal-#{assigns.size}",
        if(assigns.scroll_behavior, do: "modal-scroll-#{assigns.scroll_behavior}", else: nil),
        if(assigns.fullscreen, do: "modal-fullscreen-#{assigns.fullscreen}", else: nil)
      ])

    dialog_class =
      combine_class([
        "modal-dialog",
        assigns.dialog_class
      ])

    content_class =
      combine_class([
        "modal-content",
        assigns.content_class
      ])

    header_class =
      combine_class([
        "modal-header",
        assigns.header_class
      ])

    body_class =
      combine_class([
        "modal-body",
        assigns.body_class
      ])

    footer_class =
      combine_class([
        "modal-footer",
        assigns.footer_class
      ])

    assigns
    |> assign(:class, class)
    |> assign(:dialog_class, dialog_class)
    |> assign(:content_class, content_class)
    |> assign(:header_class, header_class)
    |> assign(:body_class, body_class)
    |> assign(:footer_class, footer_class)
  end
end
