defmodule PrenixComponents do
  defmacro __using__(_) do
    quote do
      import PrenixComponents.{
        Accordion,
        Accordion.AccordionItem,
        Alert,
        Autocomplete,
        Avatar,
        Badge,
        Button,
        Card,
        CheckboxGroup,
        Checkbox,
        Chip,
        Collapse,
        Datepicker,
        Divider,
        Dropdown,
        Icon,
        Input,
        Link,
        Modal,
        Offcanvas,
        Select,
        Spinner,
        Table,
        ThemeSwitcher,
        Toast,
        Tooltip
      }
    end
  end
end
