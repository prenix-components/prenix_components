defmodule PrenixComponents.Field do
  use Phoenix.Component
  import PrenixComponents.Helpers

  attr :name, :string, required: true
  attr :id, :string
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
          <label class="field-label" for={@id} id={"#{@id}-label"}><%= @label_text %></label>
        <% end %>

        <%= if length(@label) > 0 do %>
          <label class="field-label" for={@id} id={"#{@id}-label"}><%= render_slot(@label) %></label>
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
            aria-invalid={@invalid}
            aria-labelledby={"#{@id}-label"}
            aria-describedby={if(@helper_text || length(@helper) > 0, do: "#{@id}-helper", else: nil)}
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
          <p class="field-helper" id={"#{@id}-helper"}><%= @helper_text %></p>
        </div>
      <% end %>

      <%= if length(@helper) > 0 do %>
        <div class="field-helper-wrapper">
          <p class="field-helper" id={"#{@id}-helper"}><%= render_slot(@helper) %></p>
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

    id =
      cond do
        Map.get(assigns, :id) -> assigns.id
        true -> "field-#{random_string()}"
      end

    assigns |> assign(:class, class) |> assign(id: id)
  end
end
