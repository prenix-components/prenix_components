defmodule PrenixComponents.Helpers do
  import Phoenix.HTML

  def combine_class(list) do
    list
    |> Enum.filter(fn x -> x && String.length(x) > 0 end)
    |> Enum.join(" ")
  end

  def dasherize(string) do
    String.replace(string, [" ", "_"], "-")
  end

  def text_to_anchor(string) do
    string |> String.downcase() |> dasherize
  end

  def random_string(length \\ 10) do
    str =
      :crypto.strong_rand_bytes(length)
      |> Base.encode64()
      |> binary_part(0, length)

    String.replace(str, ["/", "+"], "-")
  end

  def html_safe_escape(string) do
    string |> html_escape() |> safe_to_string()
  end

  def remove_html_comment(string) do
    Regex.replace(~r/<\!--.*?-->/, string, "")
  end

  def translate_field_errors(field) do
    translated_field_name = translate_field_name(field.field)

    Enum.map(field.errors, fn error ->
      "#{translated_field_name} #{translate_error(error)}"
    end)
  end

  def translate_error({msg, opts}) do
    backend = Application.get_env(:prenix_components, :gettext_backend)

    cond do
      backend ->
        if count = opts[:count] do
          Gettext.dngettext(backend, "errors", msg, msg, count, opts)
        else
          Gettext.dgettext(backend, "errors", msg, opts)
        end

      true ->
        msg
    end
  end

  def merge_classes(list) do
    Enum.reduce(list, %{}, fn map, acc ->
      Enum.reduce(map, acc, fn item, acc_inner ->
        name = elem(item, 0)
        class = elem(item, 1)

        Map.update(acc_inner, name, class, fn existing_value -> "#{existing_value} #{class}" end)
      end)
    end)
  end

  def translate_field_name(field) do
    backend = Application.get_env(:prenix_components, :gettext_backend)
    field_name = "#{field}"

    cond do
      backend ->
        Gettext.gettext(backend, field_name)

      true ->
        field_name
    end
  end
end
