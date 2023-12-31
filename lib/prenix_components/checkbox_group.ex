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
  attr :checkbox_group_wrapper_class, :string, default: nil
  attr :label_class, :string, default: nil
  attr :helper_class, :string, default: nil
  attr :checkbox_label_class, :string, default: nil
  attr :checkbox_class, :string, default: nil
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
      aria-describedby={if(@helper_text || @helper != [], do: "#{@id}-helper", else: nil)}
      data-invalid={@invalid}
    >
      <span class={@label_class}>
        <%= if @label_text do %>
          <%= @label_text %>
        <% end %>

        <%= if @label != [] do %>
          <%= render_slot(@label) %>
        <% end %>
      </span>

      <div class={@checkbox_group_wrapper_class} role="presentation">
        <.checkbox
          :for={option <- @options}
          label_text={option.name}
          value={option.value}
          name={@name}
          disabled={@disabled}
          invalid={@invalid}
          checked={Enum.member?(@value, option.value)}
          label_class={@checkbox_label_class}
          checkbox_class={@checkbox_class}
        />
      </div>

      <%= if @helper_text do %>
        <p class={@helper_class} id={"#{@id}-helper"}><%= @helper_text %></p>
      <% end %>

      <%= if @helper != [] do %>
        <p class={@helper_class} id={"#{@id}-helper"}><%= render_slot(@helper) %></p>
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

    checkbox_group_wrapper_class =
      combine_class([
        "checkbox-group-wrapper",
        "#{assigns.checkbox_group_wrapper_class}"
      ])

    label_class =
      combine_class([
        "checkbox-group-label",
        "#{assigns.label_class}"
      ])

    helper_class =
      combine_class([
        "checkbox-group-helper",
        "#{assigns.helper_class}"
      ])

    id =
      cond do
        Map.get(assigns, :id) -> assigns.id
        true -> "checkbox-group-#{random_string()}"
      end

    assigns
    |> assign(:class, class)
    |> assign(:checkbox_group_wrapper_class, checkbox_group_wrapper_class)
    |> assign(:label_class, label_class)
    |> assign(:helper_class, helper_class)
    |> assign(:id, id)
  end
end
