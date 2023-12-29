defmodule PrenixComponents do
  defmacro __using__(_) do
    quote do
      import PrenixComponents.{
        Accordion,
        Autocomplete,
        Avatar,
        Button,
        CheckboxGroup,
        Checkbox,
        Chip,
        Datepicker,
        Divider,
        Dropdown,
        Icon,
        Input,
        Link,
        Modal,
        Spinner,
        Table,
        Tooltip
      }
    end
  end
end
