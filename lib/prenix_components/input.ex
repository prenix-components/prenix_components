defmodule PrenixComponents.Input do
  use Phoenix.Component
  import PrenixComponents.Helpers
  import PrenixComponents.Icon

  attr :name, :string, required: true
  attr :id, :string
  attr :value, :any, default: nil
  attr :label_text, :string, default: nil
  attr :helper_text, :string, default: nil
  attr :invalid, :boolean, default: false
  attr :disabled, :boolean, default: false
  attr :placeholder, :string, default: nil
  attr :size, :string, default: "md", values: ~w(sm md lg)
  attr :label_placement, :string, default: "inside", values: ~w(inside outside outside-left)

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

  def input(assigns) do
    assigns = set_assigns(assigns)

    ~H"""
    <div
      class={@class}
      data-invalid={@invalid}
      data-disabled={@disabled}
      data-input
      data-datepicker={@type == "datepicker"}
      data-datepicker-opts={@datepicker_opts}
    >
      <%= render_content(assigns) %>
    </div>
    """
  end

  defp set_assigns(assigns) do
    class =
      combine_class([
        "input",
        "input-#{assigns.size}",
        "input-label-#{assigns.label_placement}",
        if(assigns.type == "textarea", do: "input-textarea", else: ""),
        assigns.class
      ])

    wrapper_class =
      combine_class([
        "input-wrapper",
        assigns.wrapper_class
      ])

    label_class =
      combine_class([
        "input-label",
        assigns.label_class
      ])

    input_wrapper_class =
      combine_class([
        "input-el-wrapper",
        assigns.input_wrapper_class
      ])

    input_class =
      combine_class([
        "input-el",
        assigns.input_class
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

    datepicker_opts = Jason.encode!(%{a: 1, b: 2})
    IO.inspect(datepicker_opts)

    assigns
    |> assign(:class, class)
    |> assign(:wrapper_class, wrapper_class)
    |> assign(:label_class, label_class)
    |> assign(:input_wrapper_class, input_wrapper_class)
    |> assign(:input_class, input_class)
    |> assign(:helper_class, helper_class)
    |> assign(id: id)
    |> assign(:datepicker_opts, datepicker_opts)
  end

  defp render_label(assigns) do
    ~H"""
    <%= if @label_text do %>
      <label class={@label_class} for={@id} id={"#{@id}-label"}><%= @label_text %></label>
    <% end %>

    <%= if length(@label) > 0 do %>
      <label class={@label_class} for={@id} id={"#{@id}-label"}><%= render_slot(@label) %></label>
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
      <%= if length(@start_content) > 0 do %>
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
          aria-describedby={if(@helper_text || length(@helper) > 0, do: "#{@id}-helper", else: nil)}
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
          value={@value}
          aria-invalid={@invalid}
          aria-labelledby={"#{@id}-label"}
          aria-describedby={if(@helper_text || length(@helper) > 0, do: "#{@id}-helper", else: nil)}
          {@rest}
        />
      <% end %>

      <%= if length(@end_content) > 0 do %>
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
    <button class="datepicker-clear-btn shrink-0 inline-flex">
      <.icon name="ion-close-circle" class="text-neutral2-foreground" />
    </button>

    <.icon
      name="ion-calendar-clear-outline pointer-events-none datepicker-calendar-icon"
      class="text-neutral1-foreground block shrink-0"
    />
    """
  end

  defp render_datepicker_content(assigns) do
    ~H"""

    """
  end
end
