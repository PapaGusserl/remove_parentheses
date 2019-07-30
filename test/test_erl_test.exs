defmodule TestErlTest do
  use ExUnit.Case

  test "обычная строка" do
    assert "обычная строка" == TestErl.remove_parentheses("обычная строка")
  end

  test "строка с одним урвонем вложенности" do
    assert "яанчыбо строка" == TestErl.remove_parentheses("(обычная) строка")
  end

  test "с двумя уровнями" do
    assert "яанчобы строка" == TestErl.remove_parentheses("((обы)чная) строка")
  end

  test "сложная строка" do
    assert "наячобы строка" == TestErl.remove_parentheses("((обы)ч(ная)) строка")
  end

  test "сломанняя строка" do
    assert "нчобыая) (стр(ока" == TestErl.remove_parentheses("((обы)чн)ая) (стр(ока")
  end

  test "сломанняя строка 2" do
    assert "обы)чн)ая) (страко" == TestErl.remove_parentheses("обы)чн)ая) (стр(ока)")
  end

  test "сломанняя строка 3" do
    assert "обы)чн)ая) (стр(ока" == TestErl.remove_parentheses("обы)чн)ая) (стр(ока")
  end
end
