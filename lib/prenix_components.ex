defmodule PrenixComponents do
  defmacro __using__(_) do
    quote do
      import PrenixComponents.{
        Autocomplete,
        Badge,
        Button,
        CheckboxGroup,
        Checkbox,
        Divider,
        Dropdown,
        Icon,
        Input,
        Modal,
        Spinner,
        Table,
        Tooltip
      }
    end
  end
end
