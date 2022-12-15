
{:ok, body} = File.read("./day7_input.txt")
logs = String.split(body, "\n")
# IO.inspect(logs)


defmodule LogParser do
  
  def isCd?(log) do
    String.contains?(log, "$ cd")
  end

  def cdTopLevel?(log) do
    String.contains?(log, "$ cd /")
  end

  def isLs?(log) do
    String.contains?(log, "$ ls")
  end
  
  def isLsDir?(log, lsFlag) do
    String.contains?(log, "dir ") and lsFlag == 1
  end

  def isFile?(log, lsFlag) do
    lsFlag == 1 and not LogParser.isLsDir?(log, lsFlag) and String.contains?(log, " ")
  end

  def cdOut?(log) do
    String.contains?(log, "$ cd ..")
  end
end

defmodule FileWalker do
  def getToDir(map, pwd) do
    # IO.inspect(map)
    # IO.inspect(pwd)
  
    updatePwdWithDirNamesPath = List.flatten(List.foldl(pwd, [], fn x, acc -> 
      acc ++ [x, "dirNames"]
    end))
    updatedPwd = List.delete_at(updatePwdWithDirNamesPath, -1)
    dir =
    List.foldl(updatedPwd, map, fn path, acc -> 
      acc[path]
    end)
    
    if Map.has_key?(dir, "files") do
      # IO.inspect("infileif")
      dir["files"]
    else
      []
    end
  end

  def updateDirectory(acc, updatedDir, pwd) do
    updatePwdWithDirNamesPath = List.flatten(List.foldl(pwd, [], fn x, acc -> 
      acc ++ [x, "dirNames"]
    end))
    updatedPwd = List.delete_at(updatePwdWithDirNamesPath, -1)
    put_in(acc, updatedPwd ++ ["files"], updatedDir)
  end

  def addDir(acc, dir, pwd) do
    updatePwdWithDirNamesPath = List.flatten(List.foldl(pwd, [], fn x, acc -> 
      acc ++ [x, "dirNames"]
    end))
    currentDirMap = get_in(acc, updatePwdWithDirNamesPath) 
    newDirToAddToMap = %{dir => %{"files" => [], "dirNames" => %{}} }
    put_in(acc, updatePwdWithDirNamesPath, Map.merge(currentDirMap, newDirToAddToMap))
  end
  
end


defmodule FileSystem do
  # %{files..., dirNames...}
  def calculateDirFiles(directory, dirName) do
    # IO.inspect(dirName)
    # IO.inspect("before has key")
     if Map.has_key?(directory, "dirNames") do
     # IO.inspect("dirNames")
      dirNames = Map.get(directory, "dirNames")
      # IO.inspect(dirNames)
      listOfDirNames = Map.keys(dirNames)
      # IO.inspect(listOfDirNames)
        if length(listOfDirNames) > 0 do
          size = 0
          dirSizes = List.foldl(listOfDirNames, size, fn fileName, acc ->
              acc + FileSystem.calculate(Map.get(dirNames, fileName), fileName)
          end)
          dirSizes
        else
          0
        end
     end
  end
  def calculateFileSize(directory, dirName) do
     if Map.has_key?(directory, "files") do
        # IO.inspect("files?")
        files = Map.get(directory, "files")  
          fileSize = List.foldl(files, 0, fn file, acc ->
            acc + String.to_integer(Enum.at(file, 0))
          end)
          fileSize
     end
  end

  def calculate(directory, dirName) do
      a = calculateFileSize(directory, dirName) 
      b = calculateDirFiles(directory, dirName)
      if a + b < 100000 do
      # 70000000 - 41035571 
      # if a + b >= 1035571 and a + b < 1199999 do
        # IO.inspect(dirName)
        # IO.inspect("files size")
        # IO.inspect(a)
        # IO.inspect("dir size")
        # IO.inspect(b)
        # what gets printed should be added up
        IO.inspect(a+b)
      end
      a + b
  end
end
#
# files: [[filename, size]]
# dirNames = {
#   name: {
#     files
#     dirName: ...
#   }
# }

systemState = %{
  "pwd" => [],
  "isLs" => 0,
  "/" => %{
    "files" => [],
    "dirNames" => %{}
  }
}

# calc
# size of files[] + calc(dirNames%{})



directory =
List.foldl(logs, systemState, fn log, acc -> 
  # IO.puts("instruction:")
  # IO.puts(log)
  # IO.puts("current pwd:")
  # IO.inspect(acc["pwd"])
  cond do
    LogParser.cdTopLevel?(log) ->
      Map.put(acc, "pwd", ["/"])
       %{acc | "pwd" => ["/"]}
      # acc
    LogParser.cdOut?(log) ->
      # IO.puts("cd out?")
      pwd = get_in(acc, ["pwd"])
      # { _, updatedPwd } = List.pop_at(pwd, -1)
      updatedPwd = List.delete_at(pwd, -1)
      # IO.inspect(updatedPwd)
      # Map.replace(acc, "pwd", updatedPwd)
      put_in(acc, ["pwd"], updatedPwd)
    LogParser.isCd?(log) ->
      pwd = get_in(acc, ["pwd"])
      pathToAdd = Enum.at(String.split(log, "cd "), 1)
      
       %{acc | "pwd" => pwd ++ [pathToAdd]}
    LogParser.isLs?(log) ->
      # IO.puts("isLs")
      # set to 1
      Map.replace(acc, "isLs", 1)
    LogParser.isLsDir?(log, Map.get(acc, "isLs")) ->
      # IO.puts("isDir")
      fileSplit = String.split(log, " ")
      FileWalker.addDir(acc, Enum.at(fileSplit, 1), acc["pwd"])
      # acc
    LogParser.isFile?(log, Map.get(acc, "isLs")) ->
      directoryLevel = FileWalker.getToDir(acc, acc["pwd"]) 
      directoryWithAddedFile = directoryLevel ++ [String.split(log, " ", trim: true)]
      
      # IO.inspect(directoryWithAddedFile)
      FileWalker.updateDirectory(acc, directoryWithAddedFile, acc["pwd"])
      # IO.inspect(directoryLevel)
      # acc
    
    true -> acc
  end
end)

IO.inspect(directory)

total = FileSystem.calculate(Map.get(directory, "/"), "/")
