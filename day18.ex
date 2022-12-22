
{:ok, body} = File.read("./day18_input.txt")
coordinates = String.split(body, "\n", trim: true)

defmodule Foo do
  def find(coord, coordinates) do
    coord1 = [Enum.at(coord, 0), Enum.at(coord, 1), Enum.at(coord, 2) + 1]
    coord2 = [Enum.at(coord, 0), Enum.at(coord, 1), Enum.at(coord, 2) - 1]
    coord3 = [Enum.at(coord, 0), Enum.at(coord, 1) + 1, Enum.at(coord, 2)]
    coord4 = [Enum.at(coord, 0), Enum.at(coord, 1) - 1, Enum.at(coord, 2)]
    coord5 = [Enum.at(coord, 0) + 1, Enum.at(coord, 1) , Enum.at(coord, 2)]
    coord6 = [Enum.at(coord, 0) - 1, Enum.at(coord, 1), Enum.at(coord, 2)]

    List.foldl(coordinates, 0, fn c, acc ->
      if c == coord1 or c == coord2 or c == coord3 or c == coord4 or c == coord5 or c == coord6 do
        acc + 1
      else
         acc
      end
    end)
  end
end

coordTuples = Enum.map(coordinates, fn coord -> Enum.map(String.split(coord, ",", trim: true), fn val -> String.to_integer(val) end) end)

totalSides = length(coordTuples) * 6

noncoveredSides = List.foldl(coordTuples, totalSides, fn coordinate, acc -> 
    indexMap = coordTuples |> Enum.with_index(0) |>Enum.map(fn {k,v}->{k,v} end) |> Map.new
    index =  indexMap[coordinate]
    subCoordTuples = Enum.slice(coordTuples, index+1, length(coordTuples)-index+1)
    touches = Foo.find(coordinate, subCoordTuples)
    if touches > 0 do
      acc - (2 * touches)
    else
      acc
    end
end)
IO.inspect(noncoveredSides)

