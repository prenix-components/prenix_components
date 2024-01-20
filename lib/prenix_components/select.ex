defmodule PrenixComponents.Select do
  use Phoenix.Component
  import PrenixComponents.Helpers
  import PrenixComponents.Icon
  import PrenixComponents.Dropdown
  import PrenixComponents.Button

  attr :name, :any
  attr :id, :string, default: nil
  attr :options, :list, default: []
  attr :allow_blank, :boolean, default: false
  attr :value, :any, default: nil
  attr :label_text, :string, default: nil
  attr :helper_text, :string, default: nil
  attr :invalid, :boolean, default: false
  attr :disabled, :boolean, default: false
  attr :placeholder, :string, default: nil
  attr :size, :string, default: "md", values: ~w(sm md lg)
  attr :label_placement, :string, default: "inside", values: ~w(inside outside outside-left)
  attr :field, Phoenix.HTML.FormField
  attr :errors, :list, default: []
  attr :class, :string, default: nil
  attr :wrapper_class, :string, default: nil
  attr :label_class, :string, default: nil
  attr :select_wrapper_class, :string, default: nil
  attr :select_class, :string, default: nil
  attr :helper_class, :string, default: nil
  attr :rest, :global
  slot :label
  slot :helper
  slot :start_content
  slot :end_content

  def select(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    errors = translate_field_errors(field)

    assigns
    |> assign(field: nil, id: assigns.id || field.id)
    |> assign(:errors, errors)
    |> assign(:invalid, errors != [])
    |> assign(:name, field.name)
    |> assign(:value, field.value)
    |> select()
  end

  def select(assigns) do
    assigns = set_assigns(assigns)

    ~H"""
    <div class={@class} data-select>
      <%= render_content(assigns) %>
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
        if(assigns.invalid, do: unmerged_classes[:invalid], else: %{}),
        if(assigns.disabled, do: unmerged_classes[:disabled], else: %{})
      ])

    id =
      cond do
        Map.get(assigns, :id) -> assigns.id
        true -> "select-#{random_string()}"
      end

    selected_option = Enum.find(assigns.options, fn o -> o.value == assigns.value end)

    assigns
    |> assign(
      :class,
      combine_class([
        classes["select"],
        assigns.class
      ])
    )
    |> assign(
      :wrapper_class,
      combine_class([
        classes["select-wrapper"],
        assigns.wrapper_class
      ])
    )
    |> assign(
      :label_class,
      combine_class([
        classes["select-label"],
        assigns.label_class
      ])
    )
    |> assign(
      :select_wrapper_class,
      combine_class([
        classes["select-el-wrapper"],
        assigns.select_wrapper_class
      ])
    )
    |> assign(
      :select_class,
      combine_class([
        classes["select-el"],
        assigns.select_class
      ])
    )
    |> assign(
      :helper_class,
      combine_class([
        classes["select-helper"],
        assigns.helper_class
      ])
    )
    |> assign(id: id)
    |> assign(
      :chevron_down_icon,
      Application.get_env(:prenix_components, :chevron_down_icon, "mdi-expand-more")
    )
    |> assign(
      :checkmark_icon,
      Application.get_env(:prenix_components, :checkmark_icon, "mdi-check")
    )
    |> assign(:value_name, if(selected_option, do: selected_option.name, else: ""))
  end

  defp render_label(assigns) do
    ~H"""
    <%= if @label_text do %>
      <label class={@label_class} for={@id} id={"#{@id}-label"}><%= @label_text %></label>
    <% end %>

    <%= if @label != [] do %>
      <label class={@label_class} for={@id} id={"#{@id}-label"}><%= render_slot(@label) %></label>
    <% end %>
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

  defp render_select(assigns) do
    ~H"""
    <div class={@select_wrapper_class}>
      <%= if @start_content != [] do %>
        <div class="select-content">
          <%= render_slot(@start_content) %>
        </div>
      <% end %>

      <.dropdown auto_close="true" class="absolute">
        <:toggle></:toggle>

        <.dropdown_item
          :for={option <- @options}
          data-value={option.value}
          data-name={option.name}
          data-select-option
          disabled={Map.get(option, :disabled)}
          data-selected={if(option.value == @value, do: "true", else: "false")}
        >
          <%= option.name %>

          <:end_content>
            <.icon name={@checkmark_icon} class="select-checkmark-icon" />
          </:end_content>
        </.dropdown_item>
      </.dropdown>

      <input
        type="text"
        value={@value_name}
        readonly
        class={@select_class}
        data-select-el
        placeholder={@placeholder}
        tabindex="-1"
      />
      <input type="hidden" name={@name} value={@value} data-select-value />

      <%= if @end_content != [] do %>
        <div class="select-content">
          <%= render_slot(@end_content) %>
        </div>
      <% end %>
    </div>
    """
  end

  defp render_content(%{label_placement: "inside"} = assigns) do
    ~H"""
    <div class={@wrapper_class} tabindex="0">
      <%= render_label(assigns) %>

      <%= render_select(assigns) %>

      <.icon name={@chevron_down_icon} class="select-dropdown-icon" />
    </div>

    <%= render_helper(assigns) %>
    """
  end

  defp render_content(%{label_placement: "outside"} = assigns) do
    ~H"""
    <%= render_label(assigns) %>

    <div class={@wrapper_class} tabindex="0">
      <%= render_select(assigns) %>
      <.icon name={@chevron_down_icon} class="select-dropdown-icon" />
    </div>

    <%= render_helper(assigns) %>
    """
  end

  defp render_content(%{label_placement: "outside-left"} = assigns) do
    ~H"""
    <%= render_label(assigns) %>

    <div class="grow w-full">
      <div class={@wrapper_class} tabindex="0">
        <%= render_select(assigns) %>
        <.icon name={@chevron_down_icon} class="select-dropdown-icon" />
      </div>

      <%= render_helper(assigns) %>
    </div>
    """
  end

  defp get_classes(assigns) do
    %{
      base: %{
        "select" => "select",
        "select-wrapper" => "select-wrapper",
        "select-label" => "select-label",
        "select-el-wrapper" => "select-el-wrapper",
        "select-el" => "select-el",
        "select-helper" => "select-helper",
        "select-content" => "select-content"
      },
      sm: %{
        "select" => "select--sm",
        "select-wrapper" => "select-wrapper--sm"
      },
      md: %{
        "select" => "select--md",
        "select-wrapper" => "select-wrapper--md"
      },
      lg: %{
        "select" => "select--lg",
        "select-wrapper" => "select-wrapper--lg"
      },
      invalid: %{
        "select-wrapper" => "select-wrapper--invalid",
        "select-label" => "select-label--invalid",
        "select-helper" => "select-helper--invalid"
      },
      disabled: %{
        "select-wrapper" => "select-wrapper--disabled"
      },
      inside: %{
        "select-label" => "select-label--inside",
        "select-el-wrapper" => "select-el-wrapper--inside",
        "select-wrapper" => "select-wrapper--inside-#{assigns.size}"
      },
      outside: %{
        "select" => "select--outside",
        "select-wrapper" => "select-wrapper--outside",
        "select-label" => "select-label--outside"
      },
      "outside-left": %{
        "select" => "select--outside-left",
        "select-wrapper" => "select-wrapper--outside-left",
        "select-label" => "select-label--outside-left select-label--outside-left-#{assigns.size}"
      }
    }
  end
end
