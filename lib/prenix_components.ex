defmodule PrenixComponents do
  defmacro __using__(_) do
    quote do
      import PrenixComponents.{
        Accordion,
        Autocomplete,
        Button,
        CheckboxGroup,
        Checkbox,
        Chip,
        Divider,
        Dropdown,
        Icon,
        Input,
        Modal,
        Popover,
        Spinner,
        Table,
        Tooltip
      }
    end
  end
end
