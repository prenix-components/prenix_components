defmodule PrenixComponents.Modal do
  use Phoenix.Component
  import PrenixComponents.Helpers
  import PrenixComponents.Icon
  import PrenixComponents.Button

  @sizes [
    "sm",
    "md",
    "lg"
  ]

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
  attr :size, :string, default: "md", values: @sizes
  attr :scroll_behavior, :string, default: nil, values: @scroll_behaviors
  attr :fullscreen, :string, default: nil, values: @fullscreens

  slot :header
  slot :body
  slot :footer

  def modal(assigns) do
    assigns = set_assigns(assigns)

    ~H"""
    <div class={@class} id={@id} tabindex="-1" aria-labelledby={"#{@id}-label"} aria-hidden="true">
      <div class="modal-dialog">
        <div class="modal-content">
          <.button size="sm" icon rounded variant="ghost" class="modal-close" data-bs-dismiss="modal">
            <.icon name="hero-x-mark-mini" />
          </.button>

          <%= if length(@header) > 0 do %>
            <div class="modal-header" id={"#{@id}-label"}>
              <%= render_slot(@header) %>
            </div>
          <% end %>

          <%= if length(@body) > 0 do %>
            <div class="modal-body">
              <%= render_slot(@body) %>
            </div>
          <% end %>

          <%= if length(@footer) > 0 do %>
            <div class="modal-footer">
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

    assigns |> assign(:class, class)
  end
end
