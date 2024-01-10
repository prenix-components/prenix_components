defmodule PrenixComponents.ThemeSwitcher do
  use Phoenix.Component
  import PrenixComponents.Icon
  import PrenixComponents.Button
  import PrenixComponents.Helpers
  import PrenixComponents.Dropdown

  attr :type, :string, default: "icon", values: ~w(icon switch select)
  attr :class, :string, default: nil
  attr :button_class, :string, default: nil
  slot :inner_block

  def theme_switcher(%{type: "icon"} = assigns) do
    assigns = set_assigns(assigns)

    ~H"""
    <div class={@class} data-theme-switcher>
      <.button
        type="button"
        icon
        size="sm"
        variant="light"
        data-theme-switcher-toggle="light"
        class={combine_class(["theme-switcher-icon-light", @button_class])}
      >
        <.icon name={@light_icon} />
      </.button>

      <.button
        type="button"
        icon
        size="sm"
        variant="light"
        data-theme-switcher-toggle="dark"
        class={combine_class(["theme-switcher-icon-dark", @button_class])}
      >
        <.icon name={@dark_icon} />
      </.button>
    </div>
    """
  end

  def theme_switcher(%{type: "select"} = assigns) do
    assigns = set_assigns(assigns)

    ~H"""
    <div class={@class} data-theme-switcher>
      <.dropdown auto_close="true">
        <:toggle>
          <.button
            type="button"
            icon
            size="sm"
            variant="light"
            class={combine_class(["theme-switcher-icon-light", @button_class])}
          >
            <.icon name={@light_icon} />
          </.button>

          <.button
            type="button"
            icon
            size="sm"
            variant="light"
            class={combine_class(["theme-switcher-icon-dark", @button_class])}
          >
            <.icon name={@dark_icon} />
          </.button>
        </:toggle>

        <.dropdown_item data-theme-switcher-toggle="light" class="theme-switcher-select-light">
          Light
          <:end_content>
            <.icon name={@checkmark_icon} size="sm" />
          </:end_content>
        </.dropdown_item>

        <.dropdown_item data-theme-switcher-toggle="dark" class="theme-switcher-select-dark">
          Dark
          <:end_content>
            <.icon name={@checkmark_icon} size="sm" />
          </:end_content>
        </.dropdown_item>
      </.dropdown>
    </div>
    """
  end

  defp set_assigns(assigns) do
    assigns
    |> assign(
      :class,
      combine_class([
        assigns.class
      ])
    )
    |> assign(:light_icon, Application.get_env(:prenix_components, :light_icon, "mdi-light-mode"))
    |> assign(:dark_icon, Application.get_env(:prenix_components, :dark_icon, "mdi-dark-mode"))
    |> assign(
      :checkmark_icon,
      Application.get_env(:prenix_components, :checkmark_icon, "mdi-check")
    )
  end
end
