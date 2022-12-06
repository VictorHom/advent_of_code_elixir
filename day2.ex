{:ok, body} = File.read("./day2_input.txt")
# IO.puts(body)
rounds = String.split(body, "\n")
# IO.inspect(rounds)


moveScore = %{
  "X" => 1,
  "Y" => 2,
  "Z" => 3,
}

defmodule Game do
  # A X rock
  # B Y paper
  # C Z scissor
  def opponentPlaysA(move) do
    case move do
      "X" -> 3
      "Y" -> 6
      "Z" -> 0
       _ -> 0
    end
  end
  
  def opponentPlaysB(move) do
    case move do
      "X" -> 0
      "Y" -> 3
      "Z" -> 6
       _ -> 0
    end
  end
  
  def opponentPlaysC(move) do
    case move do
      "X" -> 6
      "Y" -> 0
      "Z" -> 3
       _ -> 0
    end
  end
  
  def roundScore(opponentMove, move) do
    case opponentMove do
      "A" -> Game.opponentPlaysA(move)
      "B" -> Game.opponentPlaysB(move)
      "C" -> Game.opponentPlaysC(move)
       _ -> 0
    end
  end
end

# 0 for lost
# 3 for draw
# 6 for win

yourScore = List.foldl(rounds, 0, fn round, acc -> 
  moves = String.split(round ," ")
  acc + Game.roundScore(Enum.at(moves, 0), Enum.at(moves, 1)) + Map.get(moveScore, Enum.at(moves, 1), 0)
  # IO.puts("----")
  # acc + 
end)

IO.puts(yourScore)
# X means you need to lose, Y means you need to end the round in a draw, and Z means you need to win. Good luck!"

