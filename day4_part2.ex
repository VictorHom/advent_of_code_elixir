
{:ok, body} = File.read("./day4_input.txt")
# IO.puts(body)
pairs = String.split(body, "\n")
# IO.inspect(pairs)
defmodule Calc do

  def inRange?(number, range) do
    if number >= Enum.at(range, 0) and number <= Enum.at(range, 1) do
      true
    else
      false
    end
  end

  def overlapAny?(rangeA, rangeB) do
    if (Calc.inRange?(Enum.at(rangeA, 0), rangeB) or inRange?(Enum.at(rangeA, 1), rangeB))
      or (Calc.inRange?(Enum.at(rangeB, 0), rangeA) or inRange?(Enum.at(rangeB, 1), rangeA)) do
      # IO.puts("in true")
      true
    else
      # IO.puts("in else")
      false
    end
  end
end

entireOverlapPairCount = 
List.foldl(pairs, 0, fn pair, accu ->
  # IO.inspect(pair)
  pairRanges = String.split(pair, ",")
  if length(pairRanges) == 2 do
    # IO.inspect(pairRanges)
    taskARange = String.split(Enum.at(pairRanges, 0), "-")
    taskBRange = String.split(Enum.at(pairRanges, 1), "-")
    taskARangeParsed = List.foldl(taskARange, [], fn val, acc ->
      # [String.to_integer(val) | acc]
      # [acc | String.to_integer(val)]
      acc ++ [String.to_integer(val)]
    end)
    taskBRangeParsed = List.foldl(taskBRange, [], fn val, acc ->
      # [String.to_integer(val) | acc]
      # [acc | String.to_integer(val)]
      acc ++ [String.to_integer(val)]
    end)
    IO.inspect("====")
    IO.inspect(taskARangeParsed)
    IO.inspect(taskBRangeParsed)
    if Calc.overlapAny?(taskARangeParsed, taskBRangeParsed) do
      IO.puts("in if")
      IO.puts(accu)
      accu + 1
    else
      accu + 0
    end
  else
    accu
  end
  # IO.puts("endloop")
  # accu + 0
  # IO.puts("here")
  # IO.inspect(taskARangeParsed)
  # IO.inspect(taskBRangeParsed)
  # foo
  # listOfTaskA =
end)

IO.puts("solution:")
IO.puts(entireOverlapPairCount)
