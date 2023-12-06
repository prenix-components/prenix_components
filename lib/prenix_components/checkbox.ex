defmodule PrenixComponents.Checkbox do
  use Phoenix.Component
  import PrenixComponents.Helpers

  attr :name, :string, required: true
  attr :value, :any, required: true
  attr :id, :string
  attr :checked, :boolean, default: false
  attr :label_text, :string, default: nil
  attr :invalid, :boolean, default: false
  attr :disabled, :boolean, default: false
  attr :class, :string, default: nil
  slot :label

  def checkbox(assigns) do
    assigns = set_assigns(assigns)

    ~H"""
    <label class={@class} for={@id} data-checkbox data-disabled={@disabled} data-invalid={@invalid}>
      <div class="checkbox-input-wrapper">
        <input
          id={@id}
          name={@name}
          aria-labelledby={"#{@id}-label"}
          aria-invalid="true"
          type="checkbox"
          value={@value}
          disabled={@disabled}
          checked={@checked}
        />
      </div>
      <span aria-hidden="true" class="checkbox-checkmark-wrapper">
        <svg aria-hidden="true" role="presentation" viewBox="0 0 17 18" class="checkbox-checkmark">
          <polyline
            fill="none"
            points="1 9 7 14 15 4"
            stroke="currentColor"
            stroke-dasharray="22"
            stroke-dashoffset="66"
            stroke-linecap="round"
            stroke-linejoin="round"
            stroke-width="2"
            style="transition: stroke-dashoffset 250ms linear 0.2s;"
          >
          </polyline>
        </svg>
      </span>
      <span id={"#{@id}-label"} class="checkbox-label">
        <%= if @label_text do %>
          <%= @label_text %>
        <% end %>

        <%= if length(@label) > 0 do %>
          <%= render_slot(@label) %>
        <% end %>
      </span>
    </label>
    """
  end

  defp set_assigns(assigns) do
    class =
      combine_class([
        "checkbox",
        "#{assigns.class}"
      ])

    id =
      cond do
        Map.get(assigns, :id) -> assigns.id
        true -> "checkbox-#{random_string()}"
      end

    assigns |> assign(:class, class) |> assign(:id, id)
  end
end
