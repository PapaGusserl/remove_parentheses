defmodule TestErl do
  @moduledoc """
  Documentation for TestErl.
  """

  @doc """
  Hello world.

  ## Examples

      iex> TestErl.hello()
      :world

  """
  def remove_parentheses(binary) do
    if have_brackets?(binary) do
      binary
      |> String.codepoints()
      |> do_remove()
      |> to_string()
    else
      binary
    end
  end

  defp do_remove(binary) do
    case split_on_last_opening_bracket(binary) do
      [first, second] ->
        case split_on_first_closing_bracket(second) do
          [new_second, third] ->
            (first ++ Enum.reverse(new_second) ++ third)
            |> Enum.join("")
            |> remove_parentheses()

          som ->
            res =
              first
              |> do_remove()
              |> String.codepoints()

            (res ++ ["("] ++ second)
            |> Enum.join("")
        end

      som ->
        IO.inspect(som)
        binary
    end
  end

  defp split_on_last_opening_bracket(binary) do
    binary
    |> find_last([])
  end

  defp split_on_first_closing_bracket(binary) do
    binary
    |> find_first([])
  end

  defp find_last([], h), do: [h]

  defp find_last(["(" | tail], h) do
    res = find_last(tail, h ++ ["("])

    if length(res) != 2 do
      [h, tail]
    else
      res
    end
  end

  defp find_last([sym | tail], h), do: find_last(tail, h ++ [sym])

  def find_first([], acc), do: acc
  def find_first([")" | tail], acc), do: [acc, tail]
  def find_first([smt | tail], acc), do: find_first(tail, acc ++ [smt])

  defp have_brackets?(binary) do
    case String.split(binary, "(", parts: 2) do
      [_, smth] -> String.split(smth, ")") >= 2
      _ -> false
    end
  end
end
