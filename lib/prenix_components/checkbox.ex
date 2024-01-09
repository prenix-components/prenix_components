defmodule PrenixComponents.Checkbox do
  use Phoenix.Component
  import PrenixComponents.Helpers

  @classes %{
    base: %{
      "checkbox" => "checkbox",
      "checkbox-label" => "checkbox-label",
      "checkbox-checkbox" => "checkbox-checkbox",
      "checkbox-checkmark" => "checkbox-checkmark",
      "checkbox-helper" => "checkbox-helper"
    },
    sm: %{
      "checkbox-checkbox" => "checkbox-checkbox--sm",
      "checkbox-label" => "checkbox-label--sm",
      "checkbox-checkmark" => "checkbox-checkmark--sm"
    },
    md: %{
      "checkbox-checkbox" => "checkbox-checkbox--md",
      "checkbox-label" => "checkbox-label--md",
      "checkbox-checkmark" => "checkbox-checkmark--md"
    },
    lg: %{
      "checkbox-checkbox" => "checkbox-checkbox--lg",
      "checkbox-label" => "checkbox-label--lg",
      "checkbox-checkmark" => "checkbox-checkmark--lg"
    },
    default: %{
      "checkbox-checkbox" => "checkbox-checkbox--default"
    },
    primary: %{
      "checkbox-checkbox" => "checkbox-checkbox--primary"
    },
    secondary: %{
      "checkbox-checkbox" => "checkbox-checkbox--secondary"
    },
    success: %{
      "checkbox-checkbox" => "checkbox-checkbox--success"
    },
    warning: %{
      "checkbox-checkbox" => "checkbox-checkbox--warning"
    },
    danger: %{
      "checkbox-checkbox" => "checkbox-checkbox--danger"
    },
    disabled: %{
      "checkbox" => "checkbox--disabled"
    },
    invalid: %{
      "checkbox-checkbox" => "checkbox-checkbox--invalid",
      "checkbox-helper" => "checkbox-helper--invalid"
    }
  }

  attr :name, :any
  attr :size, :string, default: "md", values: ~w(sm md lg)

  attr :color, :string,
    default: "primary",
    values: ~w(default primary secondary success warning danger)

  attr :value, :any, required: true
  attr :id, :string, default: nil
  attr :checked, :boolean, default: false
  attr :label_text, :string, default: nil
  attr :helper_text, :string, default: nil
  attr :invalid, :boolean, default: false
  attr :disabled, :boolean, default: false
  attr :field, Phoenix.HTML.FormField
  attr :errors, :list, default: []
  attr :class, :string, default: nil
  attr :label_class, :string, default: nil
  attr :helper_class, :string, default: nil
  attr :checkbox_class, :string, default: nil
  slot :label
  slot :helper

  def checkbox(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    errors = translate_field_errors(field)

    assigns
    |> assign(field: nil, id: assigns.id || field.id)
    |> assign(:errors, errors)
    |> assign(:invalid, errors != [])
    |> assign(:name, field.name)
    |> assign(:value, field.value)
    |> checkbox()
  end

  def checkbox(assigns) do
    assigns = set_assigns(assigns)

    ~H"""
    <div>
      <label class={@class} for={@id} data-checkbox>
        <div class="visually-hidden">
          <input
            id={@id}
            name={@name}
            aria-labelledby={"#{@id}-label"}
            aria-describedby={
              if(@helper_text || @helper != [] || @errors != [], do: "#{@id}-helper", else: nil)
            }
            aria-invalid={@invalid}
            type="checkbox"
            value={@value}
            disabled={@disabled}
            checked={@checked}
          />
        </div>
        <span aria-hidden="true" class={@checkbox_class}>
          <svg
            aria-hidden="true"
            role="presentation"
            viewBox="0 0 17 18"
            class={@checkbox_checkmark_class}
          >
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
              <polyline
                fill="none"
                points="1 9 7 14 15 4"
                stroke="currentColor"
                stroke-dasharray="22"
                stroke-dashoffset="44"
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                style="transition: stroke-dashoffset 250ms linear 0.2s;"
              >
              </polyline>
            </polyline>
          </svg>
        </span>
        <span id={"#{@id}-label"} class={@label_class}>
          <%= if @label_text do %>
            <%= @label_text %>
          <% end %>

          <%= if @label != [] do %>
            <%= render_slot(@label) %>
          <% end %>
        </span>
      </label>

      <%= render_helper(assigns) %>
    </div>
    """
  end

  defp render_helper(assigns) do
    ~H"""
    <%= if @errors != [] do %>
      <%= render_errors(assigns) %>
    <% else %>
      <%= if @helper_text do %>
        <p class={@helper_class} id={"#{@id}-helper"}><%= @helper_text %></p>
      <% end %>

      <%= if @helper != [] do %>
        <p class={@helper_class} id={"#{@id}-helper"}><%= render_slot(@helper) %></p>
      <% end %>
    <% end %>
    """
  end

  defp render_errors(assigns) do
    ~H"""
    <div id={"#{@id}-helper"}>
      <p :for={msg <- @errors} class={@helper_class}>
        <%= msg %>
      </p>
    </div>
    """
  end

  defp set_assigns(assigns) do
    classes =
      merge_classes([
        @classes[:base],
        @classes[String.to_atom(assigns.size)],
        @classes[String.to_atom(assigns.color)],
        if(assigns.disabled, do: @classes[:disabled], else: %{}),
        if(assigns.invalid, do: @classes[:invalid], else: %{})
      ])

    id =
      cond do
        Map.get(assigns, :id) -> assigns.id
        true -> "checkbox-#{random_string()}"
      end

    assigns
    |> assign(
      :class,
      combine_class([
        classes["checkbox"],
        assigns.class
      ])
    )
    |> assign(
      :checkbox_class,
      combine_class([
        classes["checkbox-checkbox"],
        assigns.checkbox_class
      ])
    )
    |> assign(
      :label_class,
      combine_class([
        classes["checkbox-label"],
        assigns.label_class
      ])
    )
    |> assign(
      :checkbox_checkmark_class,
      classes["checkbox-checkmark"]
    )
    |> assign(
      :helper_class,
      combine_class([
        classes["checkbox-helper"],
        assigns.helper_class
      ])
    )
    |> assign(:id, id)
  end
end
