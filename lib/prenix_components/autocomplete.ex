defmodule PrenixComponents.Autocomplete do
  use Phoenix.Component
  import PrenixComponents.Helpers
  import PrenixComponents.Chip

  attr :name, :string, required: true
  attr :options, :list, required: true
  attr :id, :string
  attr :value, :any, default: nil
  attr :type, :string, default: "single", values: ~w(single multiple tags)
  attr :size, :string, default: "md", values: ~w(sm md lg)
  attr :label_placement, :string, default: "inside", values: ~w(inside outside outside-left)
  attr :label_text, :string, default: nil
  attr :helper_text, :string, default: nil
  attr :invalid, :boolean, default: false
  attr :disabled, :boolean, default: false
  attr :allow_blank, :boolean, default: false
  attr :placeholder, :string, default: nil
  attr :class, :string, default: nil
  attr :wrapper_class, :string, default: nil
  attr :label_class, :string, default: nil
  attr :input_wrapper_class, :string, default: nil
  attr :input_class, :string, default: nil
  attr :helper_class, :string, default: nil

  slot :label
  slot :helper
  # slot :start_content
  # slot :end_content

  def autocomplete(%{label_placement: "inside"} = assigns) do
    assigns = set_assigns(assigns)

    ~H"""
    <div
      class={@class}
      data-invalid={@invalid}
      data-disabled={@disabled}
      data-allow-blank={@allow_blank}
      data-type={@type}
      data-autocomplete
    >
      <.chip data-autocomplete-tags-item class="hidden" radius="md" size={@chip_size}>
        {{AUTOCOMPLETE_TAGS_ITEM}}
      </.chip>

      <div class={@wrapper_class}>
        <%= render_label(assigns) %>

        <%= render_input(assigns) %>
      </div>

      <%= render_helper(assigns) %>
    </div>
    """
  end

  def autocomplete(%{label_placement: "outside"} = assigns) do
    assigns = set_assigns(assigns)

    ~H"""
    <div
      class={@class}
      data-invalid={@invalid}
      data-disabled={@disabled}
      data-allow-blank={@allow_blank}
      data-type={@type}
      data-autocomplete
    >
      <.chip data-autocomplete-tags-item class="hidden" radius="md" size={@chip_size}>
        {{AUTOCOMPLETE_TAGS_ITEM}}
      </.chip>

      <%= render_label(assigns) %>

      <div class={@wrapper_class}>
        <%= render_input(assigns) %>
      </div>

      <%= render_helper(assigns) %>
    </div>
    """
  end

  def autocomplete(%{label_placement: "outside-left"} = assigns) do
    assigns = set_assigns(assigns)

    ~H"""
    <div
      class={@class}
      data-invalid={@invalid}
      data-disabled={@disabled}
      data-allow-blank={@allow_blank}
      data-type={@type}
      data-autocomplete
    >
      <.chip data-autocomplete-tags-item class="hidden" radius="md" size={@chip_size}>
        {{AUTOCOMPLETE_TAGS_ITEM}}
      </.chip>

      <%= render_label(assigns) %>

      <div class="grow w-full">
        <div class={@wrapper_class}>
          <%= render_input(assigns) %>
        </div>

        <%= render_helper(assigns) %>
      </div>
    </div>
    """
  end

  defp set_assigns(assigns) do
    class =
      combine_class([
        "autocomplete",
        "autocomplete-#{assigns.size}",
        "autocomplete-label-#{assigns.label_placement}",
        "#{assigns.class}"
      ])

    wrapper_class =
      combine_class([
        "autocomplete-wrapper",
        assigns.wrapper_class
      ])

    label_class =
      combine_class([
        "autocomplete-label",
        assigns.label_class
      ])

    input_wrapper_class =
      combine_class([
        "autocomplete-input-wrapper",
        assigns.input_wrapper_class
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
    |> assign(:class, class)
    |> assign(:wrapper_class, wrapper_class)
    |> assign(:label_class, label_class)
    |> assign(:input_wrapper_class, input_wrapper_class)
    |> assign(:helper_class, helper_class)
    |> assign(id: id)
    |> assign(:delimited_options, delimited_options)
    |> assign(:delimited_value, delimited_value)
    |> assign(:chip_size, if(assigns.size == "sm", do: "sm", else: "md"))
  end

  defp render_label(assigns) do
    ~H"""
    <%= if @label_text do %>
      <label class={@label_class} for={@id}><%= @label_text %></label>
    <% end %>

    <%= if length(@label) > 0 do %>
      <label class={@label_class} for={@id}><%= render_slot(@label) %></label>
    <% end %>
    """
  end

  defp render_helper(assigns) do
    ~H"""
    <%= if @helper_text do %>
      <p class={@helper_class} id={"#{@id}-helper"}><%= @helper_text %></p>
    <% end %>

    <%= if length(@helper) > 0 do %>
      <p class={@helper_class} id={"#{@id}-helper"}><%= render_slot(@helper) %></p>
    <% end %>
    """
  end

  defp render_input(assigns) do
    ~H"""
    <div class={@input_wrapper_class}>
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
          aria-describedby={if(@helper_text || length(@helper) > 0, do: "#{@id}-helper", else: nil)}
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
          aria-describedby={if(@helper_text || length(@helper) > 0, do: "#{@id}-helper", else: nil)}
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
    """
  end
end
