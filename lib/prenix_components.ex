defmodule PrenixComponents do
  defmacro __using__(_) do
    quote do
      import PrenixComponents.{
        Accordion,
        Accordion.AccordionItem,
        Autocomplete,
        Avatar,
        Badge,
        Button,
        Card,
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
