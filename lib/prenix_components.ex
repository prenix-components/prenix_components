defmodule PrenixComponents do
  defmacro __using__(_) do
    quote do
      import PrenixComponents.{
        Badge,
        Button,
        Divider,
        Dropdown,
        Icon,
        Spinner
      }
    end
  end
end
