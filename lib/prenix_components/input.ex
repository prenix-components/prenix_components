defmodule PrenixComponents.Input do
  use Phoenix.Component
  import PrenixComponents.Helpers

  attr :name, :string, required: true
  attr :id, :string
  attr :value, :any, default: nil
  attr :label_text, :string, default: nil
  attr :helper_text, :string, default: nil
  attr :invalid, :boolean, default: false
  attr :disabled, :boolean, default: false
  attr :placeholder, :string, default: nil

  attr :type, :string,
    default: "text",
    values: ~w(checkbox color date datetime-local email file hidden month number password
               range radio search select tel text textarea time url week)

  attr :base_class, :string, default: nil
  attr :input_wrapper_class, :string, default: nil
  attr :label_class, :string, default: nil
  attr :input_inner_wrapper_class, :string, default: nil
  attr :input_class, :string, default: nil
  attr :helper_class, :string, default: nil
  slot :label
  slot :helper
  # slot :start_content
  # slot :end_content

  def input(assigns) do
    assigns = set_assigns(assigns)

    ~H"""
    <div class={@base_class} data-invalid={@invalid} data-disabled={@disabled} data-input>
      <div class={@input_wrapper_class}>
        <%= if @label_text do %>
          <label class={@label_class} for={@id} id={"#{@id}-label"}><%= @label_text %></label>
        <% end %>

        <%= if length(@label) > 0 do %>
          <label class={@label_class} for={@id} id={"#{@id}-label"}><%= render_slot(@label) %></label>
        <% end %>

        <div class={@input_inner_wrapper_class}>
          <input
            id={@id}
            type={@type}
            name={@name}
            class={@input_class}
            placeholder={@placeholder}
            disabled={@disabled}
            value={@value}
            aria-invalid={@invalid}
            aria-labelledby={"#{@id}-label"}
            aria-describedby={if(@helper_text || length(@helper) > 0, do: "#{@id}-helper", else: nil)}
          />
        </div>
      </div>

      <%= if @helper_text do %>
        <p class={@helper_class} id={"#{@id}-helper"}><%= @helper_text %></p>
      <% end %>

      <%= if length(@helper) > 0 do %>
        <p class={@helper_class} id={"#{@id}-helper"}><%= render_slot(@helper) %></p>
      <% end %>
    </div>
    """
  end

  defp set_assigns(assigns) do
    base_class =
      combine_class([
        "input-base",
        assigns.base_class
      ])

    input_wrapper_class =
      combine_class([
        "input-wrapper",
        assigns.input_wrapper_class
      ])

    label_class =
      combine_class([
        "input-label",
        assigns.label_class
      ])

    input_inner_wrapper_class =
      combine_class([
        "input-inner-wrapper",
        assigns.input_inner_wrapper_class
      ])

    input_class =
      combine_class([
        "input"
      ])

    helper_class =
      combine_class([
        "input-helper",
        assigns.helper_class
      ])

    id =
      cond do
        Map.get(assigns, :id) -> assigns.id
        true -> "input-#{random_string()}"
      end

    assigns
    |> assign(:base_class, base_class)
    |> assign(:input_wrapper_class, input_wrapper_class)
    |> assign(:label_class, label_class)
    |> assign(:input_inner_wrapper_class, input_inner_wrapper_class)
    |> assign(:input_class, input_class)
    |> assign(:helper_class, helper_class)
    |> assign(id: id)
  end
end
