using System;
using System.IO;
using System.Linq;
using System.Collections.Generic;
using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.VisualBasic;
using Microsoft.CodeAnalysis.VisualBasic.Syntax;

class Program
{
    static void Main(string[] args)
    {
        if (args.Length < 2)
        {
            Console.WriteLine("Usage: VbParser <ProgramName> <file.vb>");
            return;
        }

        var programName = args[0];
        var inputFile = args[1];

        var repoRoot = FindRepoRoot();

        var code = File.ReadAllText(inputFile);
        var tree = VisualBasicSyntaxTree.ParseText(code);
        var root = tree.GetRoot();

        // ===== Find Class Name =====
        var classNode = root
            .DescendantNodes()
            .OfType<ClassBlockSyntax>()
            .FirstOrDefault();

        var className = classNode?
            .ClassStatement
            .Identifier
            .Text ?? "UnknownClass";

        // Replace "cls" in classname with ""
        className = className.Replace("cls", "", StringComparison.OrdinalIgnoreCase);

        // ===== Extract Class Signature =====
        var classSignature = ExtractClassSignature(classNode);

        var outputDir = Path.Combine(repoRoot, "chunks_vb", programName, className);
        Directory.CreateDirectory(outputDir);

        int index = 1;
        var signatures = new List<string>();

        // ===== Save Class Signature First =====
        if (classNode != null)
        {
            var classSignatureOnly = ExtractClassSignatureOnly(classNode);
            File.WriteAllText(
                Path.Combine(outputDir, $"ClassDeclaration.txt"),
                classSignatureOnly
            );
        }

        void Save(SyntaxNode? node, string name, string signature)
        {
            if (node == null)
                return;

            var fileName = $"{index:D4}_{Sanitize(name)}.vb";

            File.WriteAllText(
                Path.Combine(outputDir, fileName),
                node.ToFullString()
            );

            signatures.Add(signature.Trim());
            index++;
        }

        // ===== Subs + Functions =====
        foreach (var m in root.DescendantNodes()
                              .OfType<MethodStatementSyntax>())
        {
            var signature = m.ToString();
            Save(m.Parent, m.Identifier.Text, signature);
        }

        // ===== Constructors =====
        foreach (var c in root.DescendantNodes()
                              .OfType<SubNewStatementSyntax>())
        {
            var signature = c.ToString();
            Save(c.Parent, "Constructor", signature);
        }

        // ===== Write manifest =====
        var listFile = Path.Combine(outputDir, "functions.txt");
        File.WriteAllLines(listFile, signatures);

        Console.WriteLine($"Class: {className}");
        Console.WriteLine($"Created {index - 1} VB chunks.");
        Console.WriteLine($"Output: {outputDir}");
        Console.WriteLine($"Signatures: {listFile}");
    }

    static string ExtractClassSignatureOnly(ClassBlockSyntax? classNode)
    {
        if (classNode?.ClassStatement == null)
            return string.Empty;

        var classStatement = classNode.ClassStatement;
        var signatureParts = new List<string>();
        
        // Class keyword and name
        signatureParts.Add($"{classStatement.ClassKeyword.Text} {classStatement.Identifier.Text}");

        // Use Roslyn to find InheritsStatementSyntax nodes
        var inheritsStatements = classNode.DescendantNodes().OfType<InheritsStatementSyntax>();
        foreach (var inherits in inheritsStatements)
        {
            signatureParts.Add(inherits.ToString());
        }

        // Use Roslyn to find ImplementsStatementSyntax nodes
        var implementsStatements = classNode.DescendantNodes().OfType<ImplementsStatementSyntax>();
        foreach (var implements in implementsStatements)
        {
            signatureParts.Add(implements.ToString());
        }

        return string.Join(Environment.NewLine, signatureParts);
    }

    static string ExtractClassSignature(ClassBlockSyntax? classNode)
    {
        if (classNode?.ClassStatement == null)
            return string.Empty;

        var classStatement = classNode.ClassStatement;
        var signatureParts = new List<string>();
        
        // Class keyword and name
        signatureParts.Add($"{classStatement.ClassKeyword.Text} {classStatement.Identifier.Text}");

        // Use Roslyn to find InheritsStatementSyntax nodes
        var inheritsStatements = classNode.DescendantNodes().OfType<InheritsStatementSyntax>();
        foreach (var inherits in inheritsStatements)
        {
            signatureParts.Add(inherits.ToString());
        }

        // Use Roslyn to find ImplementsStatementSyntax nodes
        var implementsStatements = classNode.DescendantNodes().OfType<ImplementsStatementSyntax>();
        foreach (var implements in implementsStatements)
        {
            signatureParts.Add(implements.ToString());
        }

        return string.Join(" ", signatureParts);
    }

    static string Sanitize(string name)
    {
        foreach (var c in Path.GetInvalidFileNameChars())
            name = name.Replace(c, '_');

        return name;
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
}
