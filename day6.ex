{:ok, body} = File.read("./day6_input.txt")
# message = String.split(body, "\n")
# IO.puts(message)

String.split(body, "")
|> Enum.with_index
|> Enum.each(fn({x, i}) ->
  if i >= 3  do
    # IO.puts("#{i} => #{x}")
    fourCharacter = String.slice(body, i-3, 4)
    fourCharacterSplit = String.split(fourCharacter, "", trim: true)
    # IO.puts(String.length(fourCharacter)) 
    # IO.puts(MapSet.size(MapSet.new(fourCharacter)))
    if MapSet.size(MapSet.new(fourCharacterSplit)) == String.length(fourCharacter) do
      # add 1 to i for position
      # dbg to stop at first spot
      IO.puts(i)
      # dbg()
    end
  end
  
end)
