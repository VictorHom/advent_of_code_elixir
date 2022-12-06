
{:ok, body} = File.read("./day2_input.txt")
# IO.puts(body)
rounds = String.split(body, "\n")
# IO.inspect(rounds)

map = %{
  "A" => %{
    "X" =>  3,
    "Y" => 1,
    "Z" => 2,
  },
  "B" => %{
    "X" => 1,
    "Y" => 2,
    "Z" => 3,
  },
  "C" => %{
    "X" => 2,
    "Y" => 3,
    "Z" => 1
  }
}

defmodule Game do
  # X means you need to lose, Y means you need to end the round in a draw, and Z means you need to win. Good luck!"
  # A rock 1
  # B paper 2
  # C scissor 3
  
  def opponentPlays(move) do
    case move do
      "X" -> 0
      "Y" -> 3
      "Z" -> 6
       _ -> 0
    end
  end
  
  def roundScore(move) do
    Game.opponentPlays(move)
  end
end

# 0 for lost
# 3 for draw
# 6 for win

yourScore = List.foldl(rounds, 0, fn round, acc -> 
  moves = String.split(round ," ")
  innerMap = Map.get(map, Enum.at(moves, 0))
  if innerMap === :nil do
    acc + Game.roundScore(Enum.at(moves, 1))
  else
    acc + Game.roundScore(Enum.at(moves, 1)) + Map.get(innerMap, Enum.at(moves, 1), 0) 
  end
end)

IO.puts(yourScore)

