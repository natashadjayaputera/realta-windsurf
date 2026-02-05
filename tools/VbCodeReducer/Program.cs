using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;

namespace VbCodeReducer
{
    class Program
    {
        static void Main(string[] args)
        {
            if (args.Length == 0)
            {
                Console.WriteLine("Usage: VbCodeReducer <path> [--split] [--debug]");
                Console.WriteLine("Example: VbCodeReducer \"C:\\path\\to\\your\\file.vb\"");
                Console.WriteLine("Example with splitting: VbCodeReducer \"C:\\path\\to\\your\\file.vb\" --split");
                Console.WriteLine("Example for folder: VbCodeReducer \"C:\\path\\to\\folder\"");
                Console.WriteLine("Example for folder with splitting: VbCodeReducer \"C:\\path\\to\\folder\" --split");
                Console.WriteLine("Example with debug (creates backups): VbCodeReducer \"C:\\path\\to\\folder\" --split --debug");
                return;
            }

            string path = args[0];
            bool shouldSplit = args.Contains("--split");
            bool debugMode = args.Contains("--debug");
            
            if (Directory.Exists(path))
            {
                // Process all VB files in the directory
                ProcessAllFilesInDirectory(path, shouldSplit, debugMode);
            }
            else if (File.Exists(path))
            {
                // Process single file
                ProcessSingleFile(path, shouldSplit, debugMode);
            }
            else
            {
                Console.WriteLine($"Error: Path '{path}' not found.");
                return;
            }
        }

        static void ProcessSingleFile(string filePath, bool shouldSplit, bool debugMode)
        {
            try
            {
                string originalContent = File.ReadAllText(filePath, Encoding.UTF8);
                var lines = originalContent.Split('\n');
                
                // Only process files with more than chunkSize lines
                // Define chunk size based on file size
                int chunkSize = 100;
                if (lines.Length <= chunkSize)
                {
                    Console.WriteLine($"File has {lines.Length} lines (≤{chunkSize}), skipping reduction and splitting");
                    return;
                }
                
                string reducedContent = ReduceVbCode(originalContent);
                
                // Create backup only in debug mode
                if (debugMode)
                {
                    string backupPath = filePath + ".backup";
                    File.Copy(filePath, backupPath, true);
                    Console.WriteLine($"Backup created: {backupPath}");
                }
                
                // Write reduced content
                File.WriteAllText(filePath, reducedContent, Encoding.UTF8);
                Console.WriteLine($"File reduced successfully: {filePath}");
                
                // Show statistics
                int originalLines = lines.Length;
                int reducedLines = reducedContent.Split('\n').Length;
                int reduction = originalLines - reducedLines;
                double percentage = (double)reduction / originalLines * 100;
                
                Console.WriteLine($"Lines reduced: {reduction} ({percentage:F1}%)");
                Console.WriteLine($"Original lines: {originalLines}");
                Console.WriteLine($"Reduced lines: {reducedLines}");
                
                // Split into chunks if requested
                if (shouldSplit && reducedLines > chunkSize)
                {
                    SplitFileIntoChunks(filePath, reducedContent, chunkSize);
                    // Delete the original file after creating chunks
                    File.Delete(filePath);
                    Console.WriteLine($"Original file deleted: {filePath}");
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error processing file '{filePath}': {ex.Message}");
            }
        }

        static void ProcessAllFilesInDirectory(string directoryPath, bool shouldSplit, bool debugMode)
        {
            try
            {
                Console.WriteLine($"Processing all VB files in: {directoryPath}");
                Console.WriteLine($"Split mode: {(shouldSplit ? "Enabled" : "Disabled")}");
                Console.WriteLine($"Debug mode: {(debugMode ? "Enabled (backups created)" : "Disabled (no backups)")}");
                Console.WriteLine(new string('-', 50));
                
                // Get all .vb files in the directory (direct children only)
                var vbFiles = Directory.GetFiles(directoryPath, "*.vb")
                    .Where(file => !file.EndsWith(".backup"))
                    .OrderBy(file => file)
                    .ToArray();
                
                if (vbFiles.Length == 0)
                {
                    Console.WriteLine("No .vb files found in the directory.");
                    return;
                }
                
                Console.WriteLine($"Found {vbFiles.Length} .vb files to process.");
                Console.WriteLine();
                
                int successCount = 0;
                int errorCount = 0;
                
                foreach (string filePath in vbFiles)
                {
                    string fileName = Path.GetFileName(filePath);
                    Console.WriteLine($"Processing: {fileName}");
                    
                    try
                    {
                        ProcessSingleFile(filePath, shouldSplit, debugMode);
                        successCount++;
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine($"ERROR processing {fileName}: {ex.Message}");
                        errorCount++;
                    }
                    
                    Console.WriteLine();
                }
                
                Console.WriteLine(new string('-', 50));
                Console.WriteLine($"Processing complete!");
                Console.WriteLine($"Successfully processed: {successCount} files");
                Console.WriteLine($"Errors: {errorCount} files");
                Console.WriteLine($"Total files: {vbFiles.Length}");
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error processing directory: {ex.Message}");
            }
        }

        static void SplitFileIntoChunks(string originalFilePath, string content, int chunkSize)
        {
            string directory = Path.GetDirectoryName(originalFilePath);
            string fileName = Path.GetFileNameWithoutExtension(originalFilePath);
            string extension = Path.GetExtension(originalFilePath);
            
            var lines = content.Split('\n');
            int totalLines = lines.Length;
            int chunkNumber = 1;
            
            Console.WriteLine($"\nSplitting file into chunks of {chunkSize} lines...");
            
            for (int i = 0; i < totalLines; i += chunkSize)
            {
                int endLine = Math.Min(i + chunkSize - 1, totalLines - 1);
                var chunkLines = new List<string>();
                
                for (int j = i; j <= endLine; j++)
                {
                    chunkLines.Add(lines[j]);
                }
                
                // Format: XXXX_FunctionName_01_chunks.vb
                string chunkFileName = $"{fileName}_{chunkNumber:D2}_chunks{extension}";
                string chunkPath = Path.Combine(directory, chunkFileName);
                
                File.WriteAllText(chunkPath, string.Join("\n", chunkLines), Encoding.UTF8);
                Console.WriteLine($"  Created: {chunkFileName} (lines {i + 1}-{endLine + 1})");
                
                chunkNumber++;
            }
            
            Console.WriteLine($"Total chunks created: {chunkNumber - 1}");
        }

        static string ReduceVbCode(string content)
        {
            // Step 1: Convert multi-line strings and concatenations to single lines
            // string step1 = ConvertMultiLineStrings(content);
            
            // Step 2: Remove consecutive empty lines (>1)
            string step2 = RemoveConsecutiveEmptyLines(content);
            
            // Step 3: Remove comments
            string step3 = RemoveComments(step2);
            
            // Step 4: Reduce multiple spaces to single spaces
            string step4 = ReduceMultipleSpacesInContent(step3);
            
            return step4;
        }

        static string ConvertMultiLineStrings(string content)
        {
            var lines = content.Split('\n');
            var result = new List<string>();
            var currentStringLines = new List<string>();
            bool inStringConcatenation = false;

            for (int i = 0; i < lines.Length; i++)
            {
                string line = lines[i];
                string trimmedLine = line.TrimEnd();

                // Check if this line is part of a string concatenation
                bool hasConcatenation = trimmedLine.Contains(" & ") || trimmedLine.EndsWith("&");
                bool isStringFormat = trimmedLine.Contains("String.Format(");
                bool continuesString = trimmedLine.Trim().StartsWith("\"") || (inStringConcatenation && trimmedLine.Trim().StartsWith("\""));

                if (hasConcatenation || isStringFormat || continuesString)
                {
                    if (!inStringConcatenation)
                    {
                        inStringConcatenation = true;
                        currentStringLines.Clear();
                    }
                    currentStringLines.Add(trimmedLine);
                    
                    // Check if this string concatenation continues
                    bool continues = trimmedLine.EndsWith("&") || 
                                    (isStringFormat && !HasCompleteStringFormat(currentStringLines.Concat(new[] { trimmedLine })));
                    
                    if (!continues)
                    {
                        // Process the complete string concatenation
                        string processedLine = ProcessStringConcatenation(currentStringLines);
                        result.Add(processedLine);
                        inStringConcatenation = false;
                        currentStringLines.Clear();
                    }
                }
                else
                {
                    if (inStringConcatenation)
                    {
                        // Process any pending string concatenation
                        string processedLine = ProcessStringConcatenation(currentStringLines);
                        result.Add(processedLine);
                        inStringConcatenation = false;
                        currentStringLines.Clear();
                    }
                    result.Add(trimmedLine);
                }
            }

            // Handle any remaining string concatenation
            if (inStringConcatenation && currentStringLines.Count > 0)
            {
                string processedLine = ProcessStringConcatenation(currentStringLines);
                result.Add(processedLine);
            }

            return string.Join("\n", result);
        }

        static bool HasCompleteStringFormat(IEnumerable<string> lines)
        {
            string combined = string.Join(" ", lines);
            int parenCount = 0;
            
            foreach (char c in combined)
            {
                if (c == '(') parenCount++;
                else if (c == ')') parenCount--;
            }
            
            return parenCount <= 0; // Complete when we have matching or more closing than opening
        }

        static string ProcessStringConcatenation(List<string> lines)
        {
            if (lines.Count == 0) return "";
            if (lines.Count == 1) return lines[0];

            var joined = new StringBuilder();
            bool isStringFormat = lines[0].Contains("String.Format(");
            
            for (int i = 0; i < lines.Count; i++)
            {
                string line = lines[i];
                
                // Remove trailing & character
                if (line.EndsWith("&"))
                {
                    line = line.Substring(0, line.Length - 1).TrimEnd();
                }
                
                // Remove leading indentation from subsequent lines
                if (i > 0)
                {
                    line = line.Trim();
                }
                
                // Merge string parts properly
                if (joined.Length > 0)
                {
                    // If the previous part ends with a quote and this part starts with a quote, merge them
                    if (joined[joined.Length - 1] == '"' && line.StartsWith("\""))
                    {
                        joined.Length--; // Remove trailing quote
                        joined.Append(line.Substring(1)); // Add current part without starting quote
                    }
                    else
                    {
                        joined.Append(" ").Append(line); // Add space between parts
                    }
                }
                else
                {
                    joined.Append(line);
                }
            }

            return joined.ToString();
        }

        static string RemoveConsecutiveEmptyLines(string content)
        {
            var lines = content.Split('\n');
            var result = new List<string>();
            int consecutiveEmptyLines = 0;
            
            foreach (string line in lines)
            {
                if (string.IsNullOrWhiteSpace(line))
                {
                    consecutiveEmptyLines++;
                    // Only add one empty line for consecutive empty lines
                    if (consecutiveEmptyLines == 1)
                    {
                        result.Add(line);
                    }
                }
                else
                {
                    consecutiveEmptyLines = 0;
                    result.Add(line);
                }
            }

            return string.Join("\n", result);
        }

        static string RemoveComments(string content)
        {
            var lines = content.Split('\n');
            var result = new List<string>();
            
            foreach (string line in lines)
            {
                string trimmed = line.Trim();
                // Skip comment lines (lines starting with single quote)
                if (!trimmed.StartsWith("'"))
                {
                    result.Add(line);
                }
            }

            return string.Join("\n", result);
        }

        static string ReduceMultipleSpacesInContent(string content)
        {
            var lines = content.Split('\n');
            var result = new List<string>();
            
            foreach (string line in lines)
            {
                result.Add(ReduceMultipleSpaces(line));
            }

            return string.Join("\n", result);
        }

        static string ReduceMultipleSpaces(string input)
        {
            // Use regex to replace multiple spaces with single space
            // But preserve leading indentation spaces
            var leadingSpacesMatch = System.Text.RegularExpressions.Regex.Match(input, @"^ *");
            var leadingSpaces = leadingSpacesMatch.Value;
            var remainingContent = input.Substring(leadingSpaces.Length);
            
            // Replace multiple spaces in the remaining content
            remainingContent = System.Text.RegularExpressions.Regex.Replace(remainingContent, @" +", " ");
            
            return leadingSpaces + remainingContent;
        }
    }
}
