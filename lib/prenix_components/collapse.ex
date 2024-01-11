defmodule PrenixComponents.Collapse do
  use Phoenix.Component
  import PrenixComponents.Helpers

  attr :id, :string, required: true
  attr :class, :string, default: nil
  attr :orientation, :string, default: "vertical", values: ~w(vertical horizontal)
  slot :inner_block

  def collapse(assigns) do
    ~H"""
    <div class={["collapse prenix-collapse", "collapse-#{@orientation}", @class]} id={@id}>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  attr :collapse_id, :string, required: true
  attr :class, :string, default: nil
  slot :inner_block, required: true

  def collapse_toggle(assigns) do
    ~H"""
    <div
      class={["collapse-toggle", @class]}
      data-bs-toggle="collapse"
      data-bs-target={"##{@collapse_id}"}
      aria-controls={@collapse_id}
    >
      <%= render_slot(@inner_block) %>
    </div>
    """
  end
end
