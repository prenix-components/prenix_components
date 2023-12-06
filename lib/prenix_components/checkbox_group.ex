defmodule PrenixComponents.CheckboxGroup do
  use Phoenix.Component
  import PrenixComponents.Helpers
  import PrenixComponents.Checkbox

  attr :name, :string, required: true
  attr :options, :list, required: true
  attr :value, :list, default: []
  attr :id, :string
  attr :label_text, :string, default: nil
  attr :helper_text, :string, default: nil
  attr :invalid, :boolean, default: false
  attr :disabled, :boolean, default: false
  attr :class, :string, default: nil
  slot :label
  slot :helper

  def checkbox_group(assigns) do
    assigns = set_assigns(assigns)

    ~H"""
    <div
      class={@class}
      role="group"
      data-checkbox-group
      id={@id}
      aria-describedby={if(@helper_text || length(@helper) > 0, do: "#{@id}-helper", else: nil)}
      data-invalid={@invalid}
    >
      <span class="checkbox-group-label">
        <%= if @label_text do %>
          <%= @label_text %>
        <% end %>

        <%= if length(@label) > 0 do %>
          <%= render_slot(@label) %>
        <% end %>
      </span>

      <div class="checkbox-group-checkboxes" role="presentation">
        <.checkbox
          :for={option <- @options}
          label_text={option.name}
          value={option.value}
          name={@name}
          disabled={@disabled}
          invalid={@invalid}
          checked={Enum.member?(@value, option.value)}
        />
      </div>

      <%= if @helper_text do %>
        <div class="checkbox-group-helper-wrapper">
          <p class="checkbox-group-helper" id={"#{@id}-helper"}><%= @helper_text %></p>
        </div>
      <% end %>

      <%= if length(@helper) > 0 do %>
        <div class="checkbox-group-helper-wrapper">
          <p class="checkbox-group-helper" id={"#{@id}-helper"}><%= render_slot(@helper) %></p>
        </div>
      <% end %>
    </div>
    """
  end

  defp set_assigns(assigns) do
    class =
      combine_class([
        "checkbox-group",
        "#{assigns.class}"
      ])

    id =
      cond do
        Map.get(assigns, :id) -> assigns.id
        true -> "checkbox-group-#{random_string()}"
      end

    assigns |> assign(:class, class) |> assign(:id, id)
  end
end
