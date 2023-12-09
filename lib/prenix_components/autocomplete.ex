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
  attr :class, :string, default: nil
  attr :placeholder, :string, default: nil
  slot :label
  slot :helper
  slot :start_content
  slot :end_content

  def autocomplete(assigns) do
    assigns = set_assigns(assigns)

    ~H"""
    <div
      class={@class}
      data-invalid={@invalid}
      data-disabled={@disabled}
      data-autocomplete
      data-allow-blank={@allow_blank}
      data-type={@type}
    >
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

          <%= if @type == "tags" do %>
            <input
              type="text"
              class="autocomplete-original-input"
              id={@id}
              autocomplete="off"
              placeholder={@placeholder}
              disabled={@disabled}
              value={if(is_list(@value), do: Enum.join(@value, ","), else: @value)}
              data-original-input
            />
          <% else %>
            <select
              class="autocomplete-original-input"
              id={@id}
              autocomplete="off"
              placeholder={@placeholder}
              disabled={@disabled}
              multiple={@type === "multiple"}
              data-original-input
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
        "field autocomplete",
        "autocomplete-#{assigns.type}",
        "#{assigns.class}"
      ])

    id =
      cond do
        Map.get(assigns, :id) -> assigns.id
        true -> "autocomplete-#{random_string()}"
      end

    assigns |> assign(:class, class) |> assign(id: id)
  end
end
