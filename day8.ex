
{:ok, body} = File.read("./day8_input.txt")
treeRows = String.split(body, "\n", trim: true)

# IO.inspect(treeRows)

trees = List.foldl(treeRows, [], fn row, acc -> 
    acc ++ [String.split(row, "", trim: true)]
end)

IO.inspect(trees)
# IO.inspect(length(trees))
# IO.inspect(length(Enum.at(trees, 0)))
# IO.inspect(length(Enum.at(trees, 98)))
numOfRows = length(trees)
numOfColumns = length(Enum.at(trees, 0))
trees
|> Enum.with_index
|> Enum.each(fn({x, i}) ->
  IO.puts("#{i} => #{x}")
  total = total + 1
  
end)
IO.inspect(total)
