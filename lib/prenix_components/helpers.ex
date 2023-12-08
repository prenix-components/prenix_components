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
end
