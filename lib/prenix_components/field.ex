defmodule PrenixComponents.Field do
  use Phoenix.Component
  import PrenixComponents.Helpers

  attr :id, :string, required: true
  attr :name, :string, required: true
  attr :value, :any, default: nil
  attr :label_text, :string, default: nil
  attr :helper_text, :string, default: nil
  attr :invalid, :boolean, default: false
  attr :disabled, :boolean, default: false

  attr :type, :string,
    default: "text",
    values: ~w(checkbox color date datetime-local email file hidden month number password
               range radio search select tel text textarea time url week)

  attr :class, :string, default: nil
  attr :placeholder, :string, default: nil
  slot :label
  slot :helper
  slot :start_content
  slot :end_content

  def field(assigns) do
    assigns = set_assigns(assigns)

    ~H"""
    <div class={@class} data-invalid={@invalid} data-disabled={@disabled} data-field>
      <div class="field-wrapper">
        <%= if @label_text do %>
          <label class="field-label" for={@id}><%= @label_text %></label>
        <% end %>

        <%= if length(@label) > 0 do %>
          <label class="field-label" for={@id}><%= render_slot(@label) %></label>
        <% end %>

        <div class="field-input-wrapper">
          <%= if length(@start_content) > 0 do %>
            <div class="field-input-start-content">
              <%= render_slot(@start_content) %>
            </div>
          <% end %>

          <input
            id={@id}
            type={@type}
            name={@name}
            class="field-input"
            placeholder={@placeholder}
            disabled={@disabled}
            value={@value}
          />

          <%= if length(@end_content) > 0 do %>
            <div class="field-input-end-content">
              <%= render_slot(@end_content) %>
            </div>
          <% end %>
        </div>
      </div>

      <%= if @helper_text do %>
        <div class="field-helper-wrapper">
          <p class="field-helper"><%= @helper_text %></p>
        </div>
      <% end %>

      <%= if length(@helper) > 0 do %>
        <div class="field-helper-wrapper">
          <p class="field-helper"><%= render_slot(@helper) %></p>
        </div>
      <% end %>
    </div>
    """
  end

  defp set_assigns(assigns) do
    class =
      combine_class([
        "field",
        assigns.class
      ])

    assigns |> assign(:class, class)
  end
end
