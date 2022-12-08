lowerCaseLetters = Enum.map(?a..?z, fn(x) -> <<x :: utf8>> end)
upperCaseLetters = Enum.map(?A..?Z, fn(x) -> <<x :: utf8>> end)

# ^letterMap = %{}

# for x <- lowerCaseLetters do
#   letterMap
# end

l = lowerCaseLetters
|> Enum.with_index
|> Enum.map(fn({x, i}) ->
  %{x => i + 1}
end)

u = upperCaseLetters
|> Enum.with_index
|> Enum.map(fn({x, i}) ->
  %{x => i + 27}
end)

# IO.inspect(letterMap)
lowerCaseMap = Enum.reduce(l, &Map.merge/2)
upperCaseMap = Enum.reduce(u, &Map.merge/2)
# IO.inspect(lowerCaseMap ++ upperCasemap)
letterMap = Map.merge(lowerCaseMap, upperCaseMap)
IO.inspect(letterMap)

{:ok, body} = File.read("./day3_input.txt")
# IO.puts(body)
rucksacks = String.split(body, "\n")

prioritySum = List.foldl(rucksacks, 0, fn rucksack, acc -> 
  mid = String.length(rucksack)/2
  # IO.puts(mid)
  { leftCompartment, rightCompartment } = String.split_at(rucksack, trunc(mid))
  sortedLeftCompartment = Enum.sort(String.split(leftCompartment, ""))
  sortedRightCompartment = Enum.sort(String.split(rightCompartment, ""))

  rucksackPriority = Enum.reduce_while(sortedLeftCompartment, 0, fn x, subacc -> 
    if !(x !== "" && Enum.member?(sortedRightCompartment, x)) do
      # IO.puts("if")
      {:cont, subacc}
    else
      # IO.puts("in else") 
      # IO.puts(subacc)
      # IO.puts(letterMap[x])
      {:halt, subacc + letterMap[x]}
    end
  end)

  # IO.puts("here")
  
  acc + rucksackPriority
  
  
end)

IO.puts(prioritySum)

