defmodule PrenixComponents.Autocomplete do
  use Phoenix.Component
  import PrenixComponents.Helpers

  attr :name, :string, required: true
  attr :options, :list, required: true
  attr :id, :string
  attr :value, :any, default: nil
  attr :type, :string, default: "single", values: ~w(single multiple tags)
  attr :label_text, :string, default: nil
  attr :helper_text, :string, default: nil
  attr :invalid, :boolean, default: false
  attr :disabled, :boolean, default: false
  attr :allow_blank, :boolean, default: false
  attr :placeholder, :string, default: nil
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

  def autocomplete(assigns) do
    assigns = set_assigns(assigns)

    ~H"""
    <div
      class={@base_class}
      data-invalid={@invalid}
      data-disabled={@disabled}
      data-allow-blank={@allow_blank}
      data-type={@type}
      data-autocomplete
    >
      <div class={@input_wrapper_class}>
        <%= if @label_text do %>
          <label class={@label_class} for={@id}><%= @label_text %></label>
        <% end %>

        <%= if length(@label) > 0 do %>
          <label class={@label_class} for={@id}><%= render_slot(@label) %></label>
        <% end %>

        <div class={@input_inner_wrapper_class}>
          <%= if @type == "tags" do %>
            <input
              type="text"
              id={@id}
              autocomplete="off"
              placeholder={@placeholder}
              disabled={@disabled}
              data-original-input
              data-input-class={@input_class}
              data-options={@delimited_options}
              value={@delimited_value}
              aria-describedby={
                if(@helper_text || length(@helper) > 0, do: "#{@id}-helper", else: nil)
              }
            />
          <% else %>
            <select
              id={@id}
              autocomplete="off"
              placeholder={@placeholder}
              disabled={@disabled}
              multiple={@type === "multiple"}
              data-original-input
              data-input-class={@input_class}
              aria-describedby={
                if(@helper_text || length(@helper) > 0, do: "#{@id}-helper", else: nil)
              }
            >
              <option value=""><%= @placeholder %></option>

              <option
                :for={option <- @options}
                value={option.value}
                selected={
                  if(@type == "multiple" && is_list(@value),
                    do: Enum.member?(@value, option.value),
                    else: option.value == @value
                  )
                }
                disabled={Map.get(option, :disabled)}
                data-template={Map.get(option, :template)}
              >
                <%= option.name %>
              </option>
            </select>
          <% end %>
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
        "autocomplete-base",
        "#{assigns.base_class}"
      ])

    input_wrapper_class =
      combine_class([
        "autocomplete-wrapper",
        assigns.input_wrapper_class
      ])

    label_class =
      combine_class([
        "autocomplete-label",
        assigns.label_class
      ])

    input_inner_wrapper_class =
      combine_class([
        "autocomplete-inner-wrapper",
        assigns.input_inner_wrapper_class
      ])

    helper_class =
      combine_class([
        "autocomplete-helper",
        assigns.helper_class
      ])

    id =
      cond do
        Map.get(assigns, :id) -> assigns.id
        true -> "autocomplete-#{random_string()}"
      end

    delimited_options =
      if(assigns.type == "tags" && assigns.options && is_list(assigns.options),
        do: Enum.join(assigns.options, ","),
        else: ""
      )

    delimited_value =
      if(assigns.type == "tags" && assigns.value && is_list(assigns.value),
        do: Enum.join(assigns.value, ","),
        else: ""
      )

    assigns
    |> assign(:base_class, base_class)
    |> assign(:input_wrapper_class, input_wrapper_class)
    |> assign(:label_class, label_class)
    |> assign(:input_inner_wrapper_class, input_inner_wrapper_class)
    |> assign(:helper_class, helper_class)
    |> assign(id: id)
    |> assign(:delimited_options, delimited_options)
    |> assign(:delimited_value, delimited_value)
  end
end
