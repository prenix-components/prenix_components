# defmodule PrenixComponents.Form do
#   use Phoenix.Component

#   attr :for, :any, required: true
#   attr :as, :any, default: nil
#   attr :action, :string, default: nil

#   attr :csrf_token, :any, default: true

#   attr :multipart, :boolean, default: false
#   attr :method, :string
#   attr :rest, :global, include: ~w(autocomplete name rel enctype novalidate target)

#   slot :inner_block, required: true

#   def form_for(assigns) do
#     ~H"""
#     <.form
#       :let={f}
#       for={@for}
#       as={@as}
#       action={@action}
#       csrf_token={@csrf_token}
#       method={@method}
#       multipart={if(@multipart, do: "multipart/form-data", else: nil)}
#       {@rest}
#     >
#       <%= render_slot(@inner_block, f) %>
#     </.form>
#     """
#   end
# end
