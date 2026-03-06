using System;
using System.IO;
using System.Linq;

class Program
{
    static void Main(string[] args)
    {
        if (args.Length < 2)
        {
            Console.WriteLine("Usage: Injector <template.cs> <chunks_cs_folder>");
            return;
        }

        var templateFile = args[0];
        var chunksDir = args[1];

        var template = File.ReadAllText(templateFile);

        // Find the insertion point and its indentation
        var insertionLine = template.Split('\n')
            .FirstOrDefault(line => line.Contains("// {INSERT_MERGED_CS_FUNCTION_HERE}"));
        
        var indentation = "";
        if (insertionLine != null)
        {
            var match = System.Text.RegularExpressions.Regex.Match(insertionLine, @"^(\s*)//");
            if (match.Success)
                indentation = match.Groups[1].Value;
        }

        var chunkFiles = Directory.GetFiles(chunksDir, "*.cs")
                                .OrderBy(f => f)
                                .Select(File.ReadAllText);

        var indentedChunks = chunkFiles.Select(chunk => 
        {
            var lines = chunk.Split('\n');
            return string.Join("\n", lines.Select(line => 
                line.Trim() == "" ? line : indentation + line));
        });

        var merged = string.Join(
            Environment.NewLine + Environment.NewLine,
            indentedChunks
        );

        template = template.Replace(
            "// {INSERT_MERGED_CS_FUNCTION_HERE}",
            merged
        );

        // Overwrite the SAME file
        File.WriteAllText(templateFile, template);

        Console.WriteLine($"Updated {templateFile}");
    }
}
