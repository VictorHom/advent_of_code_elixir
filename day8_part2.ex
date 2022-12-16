
{:ok, body} = File.read("./day8_input.txt")
treeRows = String.split(body, "\n", trim: true)

# IO.inspect(treeRows)

trees = List.foldl(treeRows, [], fn row, acc -> 
    acc ++ [String.split(row, "", trim: true)]
end)

# IO.inspect(trees)
# IO.inspect(length(trees))
# IO.inspect(length(Enum.at(trees, 0)))
# IO.inspect(length(Enum.at(trees, 98)))
numOfRows = length(trees)
IO.inspect(numOfRows)
numOfColumns = length(Enum.at(trees, 0))
updatedTrees = trees |> Enum.with_index(0) |>Enum.map(fn {k,v}->{v,k} end) |> Map.new


defmodule TreeChecker do
    # hardcoded 99 
    def checkLeft(currentTreeHeight, rowNum, colNum, updatedTrees, rowsWithColumnIndex) do
        rowOfTrees = Map.get(updatedTrees, rowNum)
        visible = Enum.reduce_while(Enum.sort(Map.keys(rowsWithColumnIndex)), 0, fn currentColNum, acc -> 
            # IO.inspect("???")
            # realizing I would have to redo lots of this to work
            # wasn't sure how to loop back from tree in elixir
            cond do
            rowNum == 0 or rowNum + 1 >= 99 -> 
                {:halt, acc}
            currentColNum < colNum and String.to_integer(Map.get(rowsWithColumnIndex, currentColNum)) >= String.to_integer(currentTreeHeight) ->
                {:halt, acc}
            currentColNum >= colNum ->
                {:halt, acc}
            true ->
                {:cont, true}
            end
        end)
        visible
    end

    def checkRight(currentTreeHeight, rowNum, colNum, updatedTrees, rowsWithColumnIndex) do
        rowOfTrees = Map.get(updatedTrees, rowNum)
        visible = Enum.reduce_while(Enum.sort(Map.keys(rowsWithColumnIndex)), true, fn currentColNum, acc -> 
            # IO.inspect("======")
            cond do
            rowNum == 0 or rowNum + 1 >= 99 -> {:halt, true}
            currentColNum > colNum and String.to_integer(Map.get(rowsWithColumnIndex, currentColNum)) >= String.to_integer(currentTreeHeight) ->
                {:halt, false}
            currentColNum <= colNum ->
                {:cont, true}
            true ->
                {:cont, true}
            end
        end)
        visible
    end

    def checkUp(currentTreeHeight, rowNum, colNum, updatedTrees, rowsWithColumnIndex) do
        visible = List.foldl(Enum.sort(Map.keys(updatedTrees)), true, fn rowNumber, acc ->
           row = Map.get(updatedTrees, rowNumber)
           # IO.inspect(row)
           # IO.inspect(colNum)
           tree = Enum.at(row, colNum)
           # IO.inspect(tree)
           # IO.inspect()
           cond do
                colNum == 0 or colNum + 1 >= 99 -> true
                rowNumber < rowNum and String.to_integer(tree) >= String.to_integer(currentTreeHeight) -> 
                # IO.inspect("in false")
                false
               true -> acc
           end
        end)
        # IO.inspect(visible)
        visible
    end

    def checkDown(currentTreeHeight, rowNum, colNum, updatedTrees, rowsWithColumnIndex) do
        visible = List.foldl(Enum.sort(Map.keys(updatedTrees)), true, fn rowNumber, acc ->
           row = Map.get(updatedTrees, rowNumber)
           tree = Enum.at(row, colNum)
           cond do
                colNum == 0 or colNum + 1 >= 99 -> true
                rowNumber > rowNum and String.to_integer(tree) >= String.to_integer(currentTreeHeight) -> false
                true -> acc
           end
        end)
    end
end

totalVisible =
List.foldl(Enum.sort(Map.keys(updatedTrees)), 0, fn rowNumber, acc -> 
    # IO.inspect(rowNumber)
    rowOfTrees = Map.get(updatedTrees, rowNumber)
    
    rowsWithColumnIndex = rowOfTrees |> Enum.with_index(0) |>Enum.map(fn {k,v}->{v,k} end) |> Map.new
    

    visibleForRow = List.foldl(Enum.sort(Map.keys(rowsWithColumnIndex)), 0, fn columnNumber, colAcc -> 
        currentTreeHeight = Enum.at(Map.get(updatedTrees, rowNumber), columnNumber)
        leftCheck = TreeChecker.checkLeft(currentTreeHeight, rowNumber, columnNumber, updatedTrees, rowsWithColumnIndex)
        rightCheck = TreeChecker.checkRight(currentTreeHeight, rowNumber, columnNumber, updatedTrees, rowsWithColumnIndex)
        upCheck = TreeChecker.checkUp(currentTreeHeight, rowNumber, columnNumber, updatedTrees, rowsWithColumnIndex)
        downCheck = TreeChecker.checkDown(currentTreeHeight, rowNumber, columnNumber, updatedTrees, rowsWithColumnIndex)

        cond do
            # rowNumber - 1 < 0 or rowNumber + 1 >= numOfRows or columnNumber - 1 < 0 or columnNumber + 1 >= numOfColumns -> colAcc + 1
            leftCheck or rightCheck or upCheck or downCheck -> colAcc + 1
            true -> colAcc
        end
        
    end)
    # IO.inspect(visibleForRow)
    acc + visibleForRow
    # IO.inspect(rowsWithColumnIndex)
end)

# IO.inspect(updatedTrees)
IO.inspect(totalVisible)
