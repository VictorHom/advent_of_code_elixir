
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
# IO.inspect(numOfRows)
numOfColumns = length(Enum.at(trees, 0))
updatedTrees = trees |> Enum.with_index(0) |>Enum.map(fn {k,v}->{v,k} end) |> Map.new


defmodule TreeChecker do
    # hardcoded 99 
    def checkLeft(currentTreeHeight, rowNum, colNum, updatedTrees, rowsWithColumnIndex) do
        rowOfTrees = Map.get(updatedTrees, rowNum)
        visible = Enum.reduce_while(Enum.sort(Map.keys(rowsWithColumnIndex), :desc), 1, fn currentColNum, acc -> 
            
            cond do
            rowNum == 0 or rowNum + 1 >= 99 ->
                {:halt, acc}
            currentColNum == 0 -> 
                {:halt, acc}
            currentColNum < colNum and String.to_integer(Map.get(rowsWithColumnIndex, currentColNum)) >= String.to_integer(currentTreeHeight) ->
                {:halt, acc}
            currentColNum < colNum and String.to_integer(Map.get(rowsWithColumnIndex, currentColNum)) < String.to_integer(currentTreeHeight) ->
                {:cont, acc + 1}
            currentColNum >= colNum ->
                {:cont, acc}
            end
        end)
        visible
    end

    def checkRight(currentTreeHeight, rowNum, colNum, updatedTrees, rowsWithColumnIndex) do
        rowOfTrees = Map.get(updatedTrees, rowNum)
        visible = Enum.reduce_while(Enum.sort(Map.keys(rowsWithColumnIndex)), 1, fn currentColNum, acc -> 
            cond do
            rowNum == 0 or rowNum + 1 >= 99 -> {:halt, acc}
            currentColNum + 1 == length(rowOfTrees) ->
                {:halt, acc}
            currentColNum > colNum and String.to_integer(Map.get(rowsWithColumnIndex, currentColNum)) >= String.to_integer(currentTreeHeight) ->
                {:halt, acc}
            currentColNum > colNum and String.to_integer(Map.get(rowsWithColumnIndex, currentColNum)) < String.to_integer(currentTreeHeight) ->
                {:cont, acc + 1}
            currentColNum <= colNum ->
                {:cont, acc}
            end
        end)
        visible
    end

    def checkUp(currentTreeHeight, rowNum, colNum, updatedTrees, rowsWithColumnIndex) do
        visible = Enum.reduce_while(Enum.sort(Map.keys(updatedTrees), :desc), 1, fn rowNumber, acc ->
           row = Map.get(updatedTrees, rowNumber)
           tree = Enum.at(row, colNum)
           cond do
                colNum == 0 or colNum + 1 >= 99 -> {:halt, acc}
                rowNumber == 0 ->
                    {:halt, acc}
                rowNumber < rowNum and String.to_integer(tree) >= String.to_integer(currentTreeHeight) -> 
                    {:halt, acc}
                rowNumber < rowNum and String.to_integer(tree) < String.to_integer(currentTreeHeight) -> 
                    {:cont, acc + 1 }
                rowNumber >= rowNum ->
                    {:cont, acc}
           end
        end)
        visible
    end

    def checkDown(currentTreeHeight, rowNum, colNum, updatedTrees, rowsWithColumnIndex) do
        visible = Enum.reduce_while(Enum.sort(Map.keys(updatedTrees)), 1, fn rowNumber, acc ->
           row = Map.get(updatedTrees, rowNumber)
           tree = Enum.at(row, colNum)
           cond do
                colNum == 0 or colNum + 1 >= 99 -> {:halt, acc}
                rowNumber + 1 ==  length(Map.keys(updatedTrees))-> {:halt, acc}
                rowNumber > rowNum and String.to_integer(tree) >= String.to_integer(currentTreeHeight) -> {:halt, acc}
                rowNumber > rowNum and String.to_integer(tree) < String.to_integer(currentTreeHeight) -> {:cont, acc + 1}
                rowNumber <= rowNum ->
                    {:cont, acc}
           end
        end)
        visible
    end
end

totalVisible =
List.foldl(Enum.sort(Map.keys(updatedTrees)), [], fn rowNumber, acc -> 
    # IO.inspect(rowNumber)
    rowOfTrees = Map.get(updatedTrees, rowNumber)
    
    rowsWithColumnIndex = rowOfTrees |> Enum.with_index(0) |>Enum.map(fn {k,v}->{v,k} end) |> Map.new
    

    visibleForRow = List.foldl(Enum.sort(Map.keys(rowsWithColumnIndex)), [], fn columnNumber, colAcc -> 
        currentTreeHeight = Enum.at(Map.get(updatedTrees, rowNumber), columnNumber)
        # IO.inspect("currentHeight:")
        # IO.inspect(currentTreeHeight)
        leftCheck = TreeChecker.checkLeft(currentTreeHeight, rowNumber, columnNumber, updatedTrees, rowsWithColumnIndex)
        rightCheck = TreeChecker.checkRight(currentTreeHeight, rowNumber, columnNumber, updatedTrees, rowsWithColumnIndex)
        upCheck = TreeChecker.checkUp(currentTreeHeight, rowNumber, columnNumber, updatedTrees, rowsWithColumnIndex)
        downCheck = TreeChecker.checkDown(currentTreeHeight, rowNumber, columnNumber, updatedTrees, rowsWithColumnIndex)
        # IO.inspect("downCheck #{downCheck}") 
        # IO.inspect("upCheck #{upCheck}")
        # IO.inspect("leftCheck #{leftCheck}")
        # IO.inspect("rightCheck #{rightCheck}")
        # IO.inspect("total:  #{downCheck * upCheck * rightCheck * leftCheck}")
        cond do
            true -> [ downCheck * upCheck * leftCheck * rightCheck | colAcc] 
        end
        
    end)
    # visibleForRow  ++ acc 
    [ Enum.at(Enum.sort(visibleForRow, :desc), 0) | acc]
    # IO.inspect(rowsWithColumnIndex)
end)

# IO.inspect(updatedTrees)
# IO.inspect(totalVisible)
IO.inspect(Enum.sort(totalVisible, :desc))
# IO.inspect("hello")
# IO.inspect(totalVisible)
