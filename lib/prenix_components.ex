defmodule PrenixComponents do
  defmacro __using__(_) do
    quote do
      import PrenixComponents.{
        Autocomplete,
        Badge,
        Button,
        Divider,
        Dropdown,
        Field,
        Icon,
        Modal,
        Spinner,
        Table,
        Tooltip
      }
    end
  end
end
