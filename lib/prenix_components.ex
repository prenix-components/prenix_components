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
        Datepicker,
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
