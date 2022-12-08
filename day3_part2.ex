
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

# temp = []
# 5..10
# |> Enum.with_index
# |> Enum.reduce(0, fn({number, index}, acc) ->
#   acc + number * index
# end)

groups = Enum.chunk_every(rucksacks, 3)

groupPriority = List.foldl(groups, 0, fn group, acc ->
  # IO.puts("hello")
  # IO.inspect(group)
  if length(group) == 3 do
    first = MapSet.new(String.split(Enum.at(group, 0), ""))
    second = MapSet.new(String.split(Enum.at(group, 1), ""))
    third = MapSet.new(String.split(Enum.at(group, 2), ""))
    # dbg()
    setA = MapSet.intersection(first, second)
    setB = MapSet.intersection(first, third)
    setC = MapSet.intersection(second, third)
    
    priority = Enum.reduce_while(setA, 0, fn x, subacc -> 
      if !(x !== "" && Enum.member?(setC, x)) do
        # IO.puts("if")
        {:cont, subacc}
      else
        # IO.puts("in else") 
        # IO.puts(subacc)
        # IO.puts(letterMap[x])
        {:halt, subacc + letterMap[x]}
      end
    end)
    acc + priority
  else
    acc 
  end
  
  
  # acc + priority
end)
IO.inspect(groupPriority)
