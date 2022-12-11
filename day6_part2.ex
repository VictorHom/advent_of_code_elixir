
{:ok, body} = File.read("./day6_input.txt")
# message = String.split(body, "\n")
# IO.puts(message)

String.split(body, "")
|> Enum.with_index
|> Enum.each(fn({x, i}) ->
  if i >= 13  do
    # IO.puts("#{i} => #{x}")
    fourteenCharacter = String.slice(body, i-13, 14)
    fourteenCharacterSplit = String.split(fourteenCharacter, "", trim: true)
    # IO.puts(String.length(fourCharacter)) 
    # IO.puts(MapSet.size(MapSet.new(fourCharacter)))
    if MapSet.size(MapSet.new(fourteenCharacterSplit)) == String.length(fourteenCharacter) do
      # add 1 to i for position
      IO.puts(i)
      # dbg()
    end
  end
  
end)
