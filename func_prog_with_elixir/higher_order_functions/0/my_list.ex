defmodule MyList do
  def each([], _function), do: nil
  def each([h|t], function) do
    function.(h)
    each(t, function)
  end

  def map([], _function), do: []
  def map([head | tail], function) do
    [function.(head) | map(tail, function)]
  end

  def reduce([], acc, _function), do: acc
  def reduce([head | tail], acc, function) do
    reduce(tail, function.(head, acc), function)
  end

  def filter([], _function), do: []
  def filter([h|t], function) do
    if(function.(h)) do
      [h | filter(t, function)]
    else
      filter(t, function)
    end
  end
end