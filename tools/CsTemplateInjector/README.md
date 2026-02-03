# C# Template Injector

A tool to inject merged C# function chunks into a template file.

## Usage

```bash
dotnet run --project tools\CsTemplateInjector\CsTemplateInjector.csproj -- "template.cs" "chunks_cs\ProgramName\ClassName"
```

## Parameters

- `template.cs`: Path to the C# template file containing the insertion marker `// {INSERT_MERGED_CS_FUNCTION_HERE}`
- `chunks_cs\ProgramName\ClassName`: Path to the directory containing C# chunk files to merge

## What it does

- Reads all `*.cs` files from the specified chunks directory
- Merges them in alphabetical order with proper indentation
- Injects the merged code into the template file at the insertion marker
- Overwrites the original template file with the injected content
- Preserves the indentation context of the insertion point

## Template Requirements

The template file must contain the insertion marker:
```csharp
// {INSERT_MERGED_CS_FUNCTION_HERE}
```

## Output

The tool will:
- Show which template file was updated
- Overwrite the original template file with merged content

## Example output

```
Updated FinalClass.cs
```

## Notes

- Chunk files are processed in alphabetical order
- Each chunk is separated by double newlines
- Indentation is automatically adjusted to match the insertion point context
- The original template file is overwritten
