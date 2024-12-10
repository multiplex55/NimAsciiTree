import os, strutils

# Hardcoded default directory path
const hardcodedPath = "/path/to/default/directory"

proc printTree(path: string, prefix: string = "", isLast: bool = true, output: var string) =
  ## Recursively prints the ASCII tree for the given directory path.
  let baseName = path.splitPath().tail
  let connector = if isLast: "+-- " else: "|-- "
  let line = prefix & connector & baseName & "\n"
  echo line.strip()  # Also print to console
  output.add(line)

  let newPrefix = prefix & (if isLast: "    " else: "|   ")
  var dirs: seq[string] = @[]
  var files: seq[string] = @[]

  # Separate directories and files
  for entry in walkDir(path):
    if entry.kind == pcDir:
      dirs.add(entry.path)
    elif entry.kind == pcFile:
      files.add(entry.path)

  # Combine directories and files for proper traversal
  let allEntries = dirs & files
  for i, entry in allEntries:
    let isLastEntry = (i == allEntries.high)
    if dirExists(entry):
      printTree(entry, newPrefix, isLastEntry, output)
    else:
      let fileConnector = if isLastEntry: "+-- " else: "|-- "
      let fileLine = newPrefix & fileConnector & entry.splitPath().tail & "\n"
      echo fileLine.strip()  # Also print to console
      output.add(fileLine)

proc getValidDirectory(prompt: string): string =
  ## Prompts the user for a directory and ensures it exists.
  while true:
    echo prompt
    let inputPath = readLine(stdin).strip()
    if dirExists(inputPath):
      return inputPath
    else:
      echo "Error: Directory '" & inputPath & "' does not exist. Please try again."

proc main() =
  # Determine the initial directory to use
  var dirPath = if paramCount() > 0:
    paramStr(1)
  else:
    hardcodedPath

  # Validate the directory; prompt if invalid
  if not dirExists(dirPath):
    echo "The directory '" & dirPath & "' does not exist."
    dirPath = getValidDirectory("Please enter a valid directory path:")

  # Prompt user for an optional output file name
  var outputFile: string
  echo "Do you want to save the output to a file? Enter in the full name (with extension). (leave empty to skip):"
  outputFile = readLine(stdin).strip()

  # Generate and display tree
  echo dirPath.splitPath().tail
  var output: string = ""
  printTree(dirPath, "", true, output)

  # Write to file if a file name is specified
  if outputFile.len > 0:
    let exeDir = getCurrentDir()
    let fullPath = joinPath(exeDir, outputFile)
    try:
      writeFile(fullPath, output)
      echo "Tree saved to: ", fullPath
    except IOError:
      echo "Error: Could not write to file: ", fullPath

when isMainModule:
  main()
