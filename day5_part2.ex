
stacks = [
  ["N", "S", "D", "C", "V", "Q", "T"],
  ["M", "F", "V"],
  ["F", "Q", "W", "D", "P", "N", "H", "M"],
  ["D", "Q", "R", "T", "F"],
  ["R", "F", "M", "N", "Q", "H", "V", "B"],
  ["C", "F", "G", "N", "P", "W", "Q"],
  ["W", "F", "R", "L", "C", "T"],
  ["T", "Z", "N", "S"],
  ["M", "S", "D", "J", "R", "Q", "H", "N"]
]


{:ok, body} = File.read("./day5_modified_instructions.txt")
# IO.puts(body)
# index 0 -> how many to move
# index 1 -> from stack
# index 2 -> to stack
instructions = String.split(body, "\n")

# IO.inspect(instructions)
updatedStacks = 
List.foldl(instructions, stacks, fn instruction, acc -> 
   
  instructionClean = String.split(instruction, " ")
  if length(instructionClean) < 3 do
    acc
  else
  
    # IO.inspect(instructionClean)
    numberToMove = String.to_integer(Enum.at(instructionClean, 0))
    fromStackIndex = Enum.at(instructionClean, 1)
    toStackIndex = Enum.at(instructionClean, 2)

    fromStack = Enum.at(acc, String.to_integer(fromStackIndex)-1)
    toStack = Enum.at(acc, String.to_integer(toStackIndex)-1)
    
    {fromStackUpdated, movedCrates } = Enum.split(fromStack,  (if length(fromStack) - numberToMove > 0, do: length(fromStack) - numberToMove, else: 0))
    # IO.puts("to move:")
    # IO.puts(numberToMove)
    # IO.inspect(fromStack) 
    # IO.puts("udpated stack:")
    # IO.inspect(fromStackUpdated)
    # IO.puts("to move")
    # IO.inspect(movedCrates)

    
    # crates are reversed because it occurs in last in, first out
    # toStackUpdated = toStack ++ Enum.reverse(movedCrates)
    # crate mover 9001 doesn't require the reverse
    toStackUpdated = toStack ++ movedCrates

    updatedA = List.replace_at(acc, String.to_integer(fromStackIndex)-1, fromStackUpdated)
    updatedB = List.replace_at(updatedA, String.to_integer(toStackIndex)-1, toStackUpdated)
    # IO.inspect(updatedB)
    # IO.puts("----")
    updatedB
  end
end)
IO.inspect(updatedStacks)
