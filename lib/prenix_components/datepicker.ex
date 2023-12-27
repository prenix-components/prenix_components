defmodule PrenixComponents.Datepicker do
  use Phoenix.Component
  import PrenixComponents.Input
  import PrenixComponents.Icon
  import PrenixComponents.Helpers
  import Phoenix.LiveViewTest

  attr :name, :string, required: true
  attr :id, :string, default: nil
  attr :value, :any, default: nil
  attr :label_text, :string, default: nil
  attr :helper_text, :string, default: nil
  attr :invalid, :boolean, default: false
  attr :disabled, :boolean, default: false
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

  def datepicker(assigns) do
    id =
      cond do
        Map.get(assigns, :id) -> assigns.id
        true -> "datepicker-#{random_string()}"
      end

    assigns =
      assigns
      |> assign(:id, id)
      |> assign(:prev_arrow_html, remove_html_comment(prev_arrow_html()))
      |> assign(:next_arrow_html, remove_html_comment(next_arrow_html()))

    ~H"""
    <.input
      type="datepicker"
      name={"#{@name}-datepicker"}
      id={@id}
      value={@value}
      label_text={@label_text}
      helper_text={@helper_text}
      invalid={@invalid}
      disabled={@disabled}
      size={@size}
      label_placement={@label_placement}
      class={@class}
      wrapper_class={@wrapper_class}
      label_class={@label_class}
      input_wrapper_class={@input_wrapper_class}
      input_class={@input_class}
      helper_class={@helper_class}
      data-target={"##{@id}-hidden"}
      data-prev-arrow-html={@prev_arrow_html}
      data-next-arrow-html={@next_arrow_html}
      {@rest}
    >
      <:label>
        <%= render_slot(@label) %>
      </:label>

      <:helper>
        <%= render_slot(@helper) %>
      </:helper>

      <:start_content>
        <%= render_slot(@start_content) %>
      </:start_content>

      <:end_content>
        <%= render_slot(@end_content) %>
      </:end_content>
    </.input>

    <input type="hidden" value={@value} name={@name} id={"#{@id}-hidden"} />
    """
  end

  defp prev_arrow_html do
    assigns = %{
      name: Application.get_env(:prenix_components, :chevron_left_icon, "ion-chevron-back")
    }

    rendered_to_string(~H"""
    <.icon name={@name} />
    """)
  end

  defp next_arrow_html do
    assigns = %{
      name: Application.get_env(:prenix_components, :chevron_right_icon, "ion-chevron-forward")
    }

    rendered_to_string(~H"""
    <.icon name={@name} />
    """)
  end
end
