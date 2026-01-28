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

        var merged = string.Join(
            Environment.NewLine + Environment.NewLine,
            Directory.GetFiles(chunksDir, "*.cs")
                     .OrderBy(f => f)
                     .Select(File.ReadAllText)
        );

        template = template.Replace(
            "{INSERT_MERGED_CS_FUNCTION_HERE}",
            merged
        );

        // Overwrite the SAME file
        File.WriteAllText(templateFile, template);

        Console.WriteLine($"Updated {templateFile}");
    }
}
