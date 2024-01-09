defmodule PrenixComponents.Autocomplete do
  use Phoenix.Component
  import PrenixComponents.Helpers
  import PrenixComponents.Chip
  import PrenixComponents.Icon
  import Phoenix.LiveViewTest

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
  slot :start_content
  slot :end_content

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
      data-tag-item-template={@tag_item_template}
      data-remove-button-html={@remove_button_html}
    >
      <div class={@wrapper_class}>
        <%= render_label(assigns) %>

        <%= render_input(assigns) %>

        <div class="autocomplete-dropdown-icon">
          <.icon name={@chevron_down_icon} />
        </div>
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
      data-tag-item-template={@tag_item_template}
      data-remove-button-html={@remove_button_html}
    >
      <%= render_label(assigns) %>

      <div class={@wrapper_class}>
        <%= render_input(assigns) %>

        <div class="autocomplete-dropdown-icon">
          <.icon name={@chevron_down_icon} />
        </div>
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
      data-tag-item-template={@tag_item_template}
      data-remove-button-html={@remove_button_html}
    >
      <%= render_label(assigns) %>

      <div class="grow w-full">
        <div class={@wrapper_class}>
          <%= render_input(assigns) %>

          <div class="autocomplete-dropdown-icon">
            <.icon name={@chevron_down_icon} />
          </div>
        </div>

        <%= render_helper(assigns) %>
      </div>
    </div>
    """
  end

  defp set_assigns(assigns) do
    unmerged_classes = get_classes(assigns)

    classes =
      merge_classes([
        unmerged_classes[:base],
        unmerged_classes[String.to_atom(assigns.size)],
        unmerged_classes[String.to_atom(assigns.label_placement)],
        unmerged_classes[String.to_atom(assigns.type)],
        if(assigns.invalid, do: unmerged_classes[:invalid], else: %{}),
        if(assigns.disabled, do: unmerged_classes[:disabled], else: %{})
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

    chip_size = if(assigns.size == "sm", do: "sm", else: "md")

    assigns
    |> assign(
      :class,
      combine_class([
        classes["autocomplete"],
        assigns.class
      ])
    )
    |> assign(
      :wrapper_class,
      combine_class([
        classes["autocomplete-wrapper"],
        assigns.wrapper_class
      ])
    )
    |> assign(
      :input_class,
      combine_class([
        classes["autocomplete-input"],
        assigns.input_class
      ])
    )
    |> assign(
      :label_class,
      combine_class([
        classes["autocomplete-label"],
        assigns.label_class
      ])
    )
    |> assign(
      :input_wrapper_class,
      combine_class([
        classes["autocomplete-input-wrapper"],
        assigns.input_wrapper_class
      ])
    )
    |> assign(
      :helper_class,
      combine_class([
        classes["autocomplete-helper"],
        assigns.helper_class
      ])
    )
    |> assign(id: id)
    |> assign(:delimited_options, delimited_options)
    |> assign(:delimited_value, delimited_value)
    |> assign(
      :chevron_down_icon,
      Application.get_env(:prenix_components, :chevron_down_icon, "mdi-expand-more")
    )
    |> assign(:tag_item_template, remove_html_comment(tag_item_template(chip_size)))
    |> assign(:remove_button_html, remove_html_comment(remove_button_html()))
  end

  defp render_label(assigns) do
    ~H"""
    <%= if @label_text do %>
      <label class={@label_class} for={@id}><%= @label_text %></label>
    <% end %>

    <%= if @label != [] do %>
      <label class={@label_class} for={@id}><%= render_slot(@label) %></label>
    <% end %>
    """
  end

  defp render_helper(assigns) do
    ~H"""
    <%= if @helper_text do %>
      <p class={@helper_class} id={"#{@id}-helper"}><%= @helper_text %></p>
    <% end %>

    <%= if @helper != [] do %>
      <p class={@helper_class} id={"#{@id}-helper"}><%= render_slot(@helper) %></p>
    <% end %>
    """
  end

  defp render_input(assigns) do
    ~H"""
    <div class={@input_wrapper_class}>
      <%= if @start_content != [] do %>
        <div class="autocomplete-content">
          <%= render_slot(@start_content) %>
        </div>
      <% end %>

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
          aria-describedby={if(@helper_text || @helper != [], do: "#{@id}-helper", else: nil)}
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
          aria-describedby={if(@helper_text || @helper != [], do: "#{@id}-helper", else: nil)}
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

      <%= if @end_content != [] do %>
        <div class="autocomplete-content">
          <%= render_slot(@end_content) %>
        </div>
      <% end %>
    </div>
    """
  end

  defp get_classes(assigns) do
    %{
      base: %{
        "autocomplete" => "autocomplete",
        "autocomplete-wrapper" => "autocomplete-wrapper",
        "autocomplete-label" => "autocomplete-label",
        "autocomplete-input-wrapper" => "autocomplete-input-wrapper",
        "autocomplete-input" => "autocomplete-input",
        "autocomplete-helper" => "autocomplete-helper",
        "autocomplete-content" => "autocomplete-content"
      },
      sm: %{
        "autocomplete" => "autocomplete--sm",
        "autocomplete-wrapper" => "autocomplete-wrapper--sm"
      },
      md: %{
        "autocomplete" => "autocomplete--md",
        "autocomplete-wrapper" => "autocomplete-wrapper--md"
      },
      lg: %{
        "autocomplete" => "autocomplete--lg",
        "autocomplete-wrapper" => "autocomplete-wrapper--lg"
      },
      invalid: %{
        "autocomplete-wrapper" => "autocomplete-wrapper--invalid",
        "autocomplete-label" => "autocomplete-label--invalid",
        "autocomplete-helper" => "autocomplete-helper--invalid"
      },
      disabled: %{
        "autocomplete-wrapper" => "autocomplete-wrapper--disabled"
      },
      inside: %{
        "autocomplete-label" => "autocomplete-label--inside",
        "autocomplete-input-wrapper" => "autocomplete-input-wrapper--inside",
        "autocomplete-wrapper" => "autocomplete-wrapper--inside-#{assigns.size}"
      },
      outside: %{
        "autocomplete" => "autocomplete--outside",
        "autocomplete-wrapper" => "autocomplete-wrapper--outside",
        "autocomplete-label" => "autocomplete-label--outside"
      },
      "outside-left": %{
        "autocomplete" => "autocomplete--outside-left",
        "autocomplete-wrapper" => "autocomplete-wrapper--outside-left",
        "autocomplete-label" =>
          "autocomplete-label--outside-left autocomplete-label--outside-left-#{assigns.size}"
      },
      single: %{
        "autocomplete-wrapper" => "autocomplete-wrapper--single"
      },
      multiple: %{
        "autocomplete-wrapper" => "autocomplete-wrapper--multiple"
      },
      tags: %{
        "autocomplete-wrapper" =>
          "autocomplete-wrapper--tags autocomplete-wrapper--tags-#{assigns.size}",
        "autocomplete-label" => "autocomplete-label--tags-#{assigns.label_placement}",
        "autocomplete-input-wrapper" => "autocomplete-input-wrapper--tags",
        "autocomplete-input" => "autocomplete-input--tags"
      },
      datepicker: %{
        "autocomplete-wrapper" => "autocomplete-wrapper--datepicker"
      }
    }
  end

  defp tag_item_template(chip_size) do
    assigns = %{
      chip_size: chip_size
    }

    rendered_to_string(~H"""
    <.chip radius="md" size={@chip_size}>
      {{AUTOCOMPLETE_TAG_ITEM}}
    </.chip>
    """)
  end

  defp remove_button_html do
    assigns = %{
      name: Application.get_env(:prenix_components, :close_icon, "mdi-close")
    }

    rendered_to_string(~H"""
    <button title="Remove" class="autocomplete-remove-btn" type="button">
      <.icon name={@name} size="sm" />
    </button>
    """)
  end
end
