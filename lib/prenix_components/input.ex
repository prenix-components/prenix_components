defmodule PrenixComponents.Input do
  use Phoenix.Component
  import PrenixComponents.Helpers
  import PrenixComponents.Icon

  attr :name, :any
  attr :id, :string, default: nil
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

  attr :type, :string,
    default: "text",
    values: ~w(checkbox color date datetime-local email file hidden month number password
               range radio search select tel text textarea time url week datepicker)

  attr :class, :string, default: nil
  attr :wrapper_class, :string, default: nil
  attr :label_class, :string, default: nil
  attr :input_wrapper_class, :string, default: nil
  attr :input_class, :string, default: nil
  attr :helper_class, :string, default: nil

  attr :rest, :global,
    include: ~w(accept autocomplete capture cols disabled form list max maxlength min minlength
              multiple pattern placeholder readonly required rows size step )

  slot :label
  slot :helper
  slot :start_content
  slot :end_content

  def input(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    errors = translate_field_errors(field)

    assigns
    |> assign(field: nil, id: assigns.id || field.id)
    |> assign(:errors, errors)
    |> assign(:invalid, errors != [])
    |> assign(:name, field.name)
    |> assign(:value, field.value)
    |> input()
  end

  def input(assigns) do
    assigns = set_assigns(assigns)

    ~H"""
    <div class={@class} data-input data-datepicker={@type == "datepicker"}>
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
        if(assigns.type == "textarea", do: unmerged_classes[:textarea], else: %{}),
        if(assigns.invalid, do: unmerged_classes[:invalid], else: %{}),
        if(assigns.disabled, do: unmerged_classes[:disabled], else: %{}),
        if(assigns.type == "datepicker", do: unmerged_classes[:datepicker], else: %{})
      ])

    id =
      cond do
        Map.get(assigns, :id) -> assigns.id
        true -> "input-#{random_string()}"
      end

    assigns
    |> assign(
      :class,
      combine_class([
        classes["input"],
        assigns.class
      ])
    )
    |> assign(
      :wrapper_class,
      combine_class([
        classes["input-wrapper"],
        assigns.wrapper_class
      ])
    )
    |> assign(
      :label_class,
      combine_class([
        classes["input-label"],
        assigns.label_class
      ])
    )
    |> assign(
      :input_wrapper_class,
      combine_class([
        classes["input-el-wrapper"],
        assigns.input_wrapper_class
      ])
    )
    |> assign(
      :input_class,
      combine_class([
        classes["input-el"],
        assigns.input_class
      ])
    )
    |> assign(
      :helper_class,
      combine_class([
        classes["input-helper"],
        assigns.helper_class
      ])
    )
    |> assign(id: id)
    |> assign(
      :calendar_icon,
      Application.get_env(:prenix_components, :calendar_icon, "mdi-calendar-today")
    )
    |> assign(
      :close_circle_icon,
      Application.get_env(:prenix_components, :close_circle_icon, "mdi-cancel")
    )
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

  defp render_input(assigns) do
    ~H"""
    <div class={@input_wrapper_class}>
      <%= if @start_content != [] do %>
        <div class="input-content">
          <%= render_slot(@start_content) %>
        </div>
      <% end %>

      <%= if @type == "textarea" do %>
        <textarea
          id={@id}
          type={@type}
          name={@name}
          class={@input_class}
          placeholder={@placeholder}
          disabled={@disabled}
          value={@value}
          aria-invalid={@invalid}
          aria-labelledby={"#{@id}-label"}
          aria-describedby={
            if(@helper_text || @helper != [] || @errors != [], do: "#{@id}-helper", else: nil)
          }
          {@rest}
        ><%= Phoenix.HTML.Form.normalize_value("textarea", @value) %></textarea>
      <% else %>
        <input
          id={@id}
          type={if(@type == "datepicker", do: "text", else: @type)}
          name={@name}
          class={@input_class}
          placeholder={@placeholder}
          disabled={@disabled}
          value={Phoenix.HTML.Form.normalize_value(@type, @value)}
          aria-invalid={@invalid}
          aria-labelledby={"#{@id}-label"}
          aria-describedby={
            if(@helper_text || @helper != [] || @errors != [], do: "#{@id}-helper", else: nil)
          }
          {@rest}
        />
      <% end %>

      <%= if @end_content != [] do %>
        <div class="input-content">
          <%= render_slot(@end_content) %>
        </div>
      <% end %>
    </div>
    """
  end

  defp render_content(%{label_placement: "inside"} = assigns) do
    ~H"""
    <div class={@wrapper_class}>
      <%= render_label(assigns) %>

      <%= render_input(assigns) %>

      <%= render_datepicker_content(assigns) %>
    </div>

    <%= render_helper(assigns) %>
    """
  end

  defp render_content(%{label_placement: "outside"} = assigns) do
    ~H"""
    <%= render_label(assigns) %>

    <div class={@wrapper_class}>
      <%= render_input(assigns) %>

      <%= render_datepicker_content(assigns) %>
    </div>

    <%= render_helper(assigns) %>
    """
  end

  defp render_content(%{label_placement: "outside-left"} = assigns) do
    ~H"""
    <%= render_label(assigns) %>

    <div class="grow w-full">
      <div class={@wrapper_class}>
        <%= render_input(assigns) %>

        <%= render_datepicker_content(assigns) %>
      </div>

      <%= render_helper(assigns) %>
    </div>
    """
  end

  defp render_datepicker_content(%{type: "datepicker"} = assigns) do
    ~H"""
    <button class="datepicker-clear-btn">
      <.icon name={@close_circle_icon} />
    </button>

    <.icon name={@calendar_icon} class="datepicker-calendar-icon" />
    """
  end

  defp render_datepicker_content(assigns) do
    ~H"""

    """
  end

  defp get_classes(assigns) do
    %{
      base: %{
        "input" => "input",
        "input-wrapper" => "input-wrapper",
        "input-label" => "input-label",
        "input-el-wrapper" => "input-el-wrapper",
        "input-el" => "input-el",
        "input-helper" => "input-helper",
        "input-content" => "input-content"
      },
      sm: %{
        "input" => "input--sm",
        "input-wrapper" => "input-wrapper--sm"
      },
      md: %{
        "input" => "input--md",
        "input-wrapper" => "input-wrapper--md"
      },
      lg: %{
        "input" => "input--lg",
        "input-wrapper" => "input-wrapper--lg"
      },
      invalid: %{
        "input-wrapper" => "input-wrapper--invalid",
        "input-label" => "input-label--invalid",
        "input-helper" => "input-helper--invalid"
      },
      disabled: %{
        "input-wrapper" => "input-wrapper--disabled"
      },
      inside: %{
        "input-label" => "input-label--inside",
        "input-el-wrapper" => "input-el-wrapper--inside",
        "input-wrapper" => "input-wrapper--inside-#{assigns.size}"
      },
      outside: %{
        "input" => "input--outside",
        "input-wrapper" => "input-wrapper--outside",
        "input-label" => "input-label--outside"
      },
      "outside-left": %{
        "input" => "input--outside-left",
        "input-wrapper" => "input-wrapper--outside-left",
        "input-label" => "input-label--outside-left input-label--outside-left-#{assigns.size}"
      },
      textarea: %{
        "input-wrapper" => "input-wrapper--textarea input-wrapper--textarea-#{assigns.size}",
        "input-label" => "input-label--textarea-#{assigns.label_placement}",
        "input-el-wrapper" => "input-el-wrapper--textarea",
        "input-el" => "input-el--textarea"
      },
      datepicker: %{
        "input-wrapper" => "input-wrapper--datepicker"
      }
    }
  end
end
