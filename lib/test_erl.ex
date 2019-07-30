defmodule TestErl do
  @moduledoc """
  Documentation for TestErl.
  """

  @doc """
   функция удаления parentheses
  """
  def remove_parentheses(string) do
    if have_brackets?(string) do
      # если есть скобки - пытаемся удалить их как парные
      string
      # кастуем в чар-лист
      |> String.codepoints()
      # разбираем как чар-лист
      |> do_remove()
      # кастуем обратно
      |> to_string()
    else
      string
    end
  end

  # функция находит парные скобки и удаляет их
  defp do_remove(binary) do
    case split_on_last_opening_bracket(binary) do
      [first, second] ->
        # если нашли открывающую скобку - ищем закрывающую - естественно во второй части
        case split_on_first_closing_bracket(second) do
          [new_second, third] ->
            # если нашли закрывающую, то реверсим всё, что внутри, и объединяем списки
            # чтобы выходить вовне и искать следующие скобки
            (first ++ Enum.reverse(new_second) ++ third)
            |> do_remove()

          _ ->
            # если не нашли закрывающую, то мы должны проигнорировать всё, что будет после
            # открывающей скобки и разобрать, что было до нее - т.е. найти предущую открывающую скобку
            res = do_remove(first)

            # после того, как получили результат - его можно объединить с скобкой, которая была удалена в 
            # split_on_last_opening_bracket/1 и второй половиной
            [res] ++ ["("] ++ second
        end

      _ ->
        binary
    end
  end

  # разделение списка на две части - справа и слева от последней открывающей скобки
  defp split_on_last_opening_bracket(binary) do
    binary
    |> find_last([])
  end

  # разделение списка на две части - справа и слева от первой закрывающей скобки
  defp split_on_first_closing_bracket(binary) do
    binary
    |> find_first([])
  end

  defp find_last([], h), do: [h]

  defp find_last(["(" | tail], h) do
    # если мы найдем более позднюю скобку - то нельзя просрать эту
    res = find_last(tail, h ++ ["("])

    # если акк не нашел более поздней скобки - то берем эту
    if length(res) != 2 do
      [h | [tail]]
    else
      res
    end
  end

  defp find_last([sym | tail], h), do: find_last(tail, h ++ [sym])

  def find_first([], acc), do: acc
  def find_first([")" | tail], acc), do: [acc | [tail]]
  def find_first([smt | tail], acc), do: find_first(tail, acc ++ [smt])

  defp have_brackets?(string) do
    case String.split(string, "(", parts: 2) do
      [_, smth] -> String.split(smth, ")") >= 2
      _ -> false
    end
  end
end
