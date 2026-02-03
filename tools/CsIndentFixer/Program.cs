using System;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;

class Program
{
    static void Main(string[] args)
    {
        if (args.Length < 1)
        {
            return;
        }

        var programName = args[0];
        var repoRoot = FindRepoRoot();
        var chunksCsPath = Path.Combine(repoRoot, "chunks_cs", programName);
        
        if (!Directory.Exists(chunksCsPath))
        {
            Console.WriteLine($"Directory not found: {chunksCsPath}");
            Console.WriteLine($"Available programs in chunks_cs:");
            
            var chunksRoot = Path.Combine(repoRoot, "chunks_cs");
            if (Directory.Exists(chunksRoot))
            {
                var programs = Directory.GetDirectories(chunksRoot);
                foreach (var prog in programs)
                {
                    var progName = Path.GetFileName(prog);
                    Console.WriteLine($"  - {progName}");
                }
            }
            return;
        }

        var csFiles = Directory.GetFiles(chunksCsPath, "*.cs", SearchOption.AllDirectories);
        var fixedCount = 0;
        var errorCount = 0;

        Console.WriteLine($"Found {csFiles.Length} C# files in {programName} to process...");

        foreach (var file in csFiles)
        {
            try
            {
                var originalContent = File.ReadAllText(file);
                var fixedContent = FixIndentation(originalContent);
                
                // Only write if content actually changed
                if (fixedContent != originalContent)
                {
                    File.WriteAllText(file, fixedContent);
                    fixedCount++;
                    Console.WriteLine($"Fixed: {GetRelativePath(file, repoRoot)}");
                }
            }
            catch (Exception ex)
            {
                errorCount++;
                Console.WriteLine($"Error processing {file}: {ex.Message}");
            }
        }

        Console.WriteLine($"\nCompleted: {fixedCount} files fixed, {errorCount} errors");
    }

    static string FixIndentation(string code)
    {
        var lines = code.Split('\n');
        var result = new List<string>();
        var indentLevel = 0;
        var indentSize = 4;
        
        foreach (var line in lines)
        {
            var trimmedLine = line.Trim();
            
            // Handle closing braces that decrease indentation
            if (trimmedLine.StartsWith("}") || trimmedLine.StartsWith("]"))
            {
                indentLevel = Math.Max(0, indentLevel - 1);
            }
            
            // Add the properly indented line
            if (trimmedLine.Length > 0)
            {
                var indent = new string(' ', indentLevel * indentSize);
                result.Add($"{indent}{trimmedLine}");
            }
            else
            {
                result.Add(""); // Preserve empty lines
            }
            
            // Handle opening braces that increase indentation
            if (trimmedLine.EndsWith("{") || trimmedLine.EndsWith("["))
            {
                indentLevel++;
            }
            // Handle case statements and similar constructs
            else if (trimmedLine.StartsWith("case ") && trimmedLine.EndsWith(":"))
            {
                indentLevel++;
            }
        }
        
        return string.Join("\n", result);
    }

    static string FindRepoRoot()
    {
        var dir = Directory.GetCurrentDirectory();

        while (dir != null)
        {
            if (Directory.Exists(Path.Combine(dir, ".git")))
                return dir;

            dir = Directory.GetParent(dir)?.FullName;
        }

        return Directory.GetCurrentDirectory();
    }

    static string GetRelativePath(string fullPath, string basePath)
    {
        if (fullPath.StartsWith(basePath))
        {
            return fullPath.Substring(basePath.Length + 1);
        }
        return fullPath;
    }
}
