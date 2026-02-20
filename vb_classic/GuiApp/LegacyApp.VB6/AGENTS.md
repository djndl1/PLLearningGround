# AGENTS.md - LegacyApp.VB6 Codebase Guidelines

This file provides guidelines for agentic coding assistants working in this Visual Basic 6 (VB6) codebase.

## Project Overview

This is a VB6 ActiveX DLL project (`LegacyAppVB6.vbp`) containing utility classes and modules for array manipulation, date/time handling, file operations, and error handling. The project follows strict VB6 compatibility standards.

## Build Commands

### Building the Project

**No automated build commands available** - This is a legacy VB6 project that requires the Visual Basic 6.0 IDE for compilation.

### Testing the Project

**No automated test framework** - Testing must be performed manually through the VB6 IDE or external test applications.

**IMPORTANT**: Agents should never attempt to build or test this project automatically after editing code.

**CRITICAL RULE**: Do not build or test this project automatically without explicit instructions from the user.

## Code Style Guidelines

### File Organization
- **File Structure**: Separate files for forms (.frm), classes (.cls), and modules (.bas)
- **Naming**: Files should match their primary class/module name
- **Build Output**: Compiled to `build/` directory

### Formatting
- **Indentation**: 4 spaces (consistent with existing code)
- **Line Length**: Aim for 80-100 characters maximum
- **Variable Declarations**: Use `Option Explicit` at the top of every file

### Naming Conventions
- **Classes**: PascalCase (e.g., `Asserter`, `TextFileOutput`)
- **Modules**: PascalCase (e.g., `Arrays`, `OleDates`)
- **Methods/Functions**: PascalCase (e.g., `GetArrayLength`, `ResizeArray`)
- **Variables**: PascalCase (e.g., `GuiFileOutput`, `m_asserter`)
- **Private Fields**: Prefix with `m_` (e.g., `m_handler`)
- **Constants**: ALL_CAPS (e.g., `AssertionError`)

### Language Features
- **VB6 Compatibility**: Target Visual Basic 6.0 runtime
- **Data Types**: Use appropriate VB6 types (Long, Integer, String, Variant)
- **Error Handling**: Use `On Error` statements and custom error handlers

### Code Quality Guidelines

#### Error Handling
```vb
' Use custom error handling with Ensure module
Private Sub SomeMethod()
    On Error GoTo ErrorHandler
    ' Code here
    Ensure.IsTrue condition, ErrorCodes.TypeMismatch, "SomeMethod"
    Exit Sub
ErrorHandler:
    Err.Raise Err.Number, Err.Source, Err.Description
End Sub
```

#### Comments and Documentation
- Use single quote comments for explanations
- Document public methods with purpose, arguments, and return values using the format seen in Arrays.cls
- Use `ReDim Preserve` for dynamic array resizing (see Arrays.cls:25-30)
- **Array Operations**: Use the `Arrays` singleton class for array manipulation
- **Error Checking**: Use `Ensure.bas` for validation and precondition checking
- **Type Safety**: Use `VariantType` function for type validation
- **File Operations**: Use `TextFileOutput` class for file I/O with Scripting.FileSystemObject
- **Date/Time**: Use specialized date/time classes like `FileTimeDateTime` and `CDateTimeKind`

## Development Workflow

### Adding New Features
1. Follow existing naming and coding conventions
2. Add appropriate error handling using Ensure module patterns
3. Create tests for new functionality
4. Update documentation if necessary
5. Do not run build or test commands

### Debugging
No automatic debugging; leave it to human.

## Dependencies

### Runtime Dependencies
- Visual Basic 6.0 Runtime
- COM components referenced in GuiApp.vbp
- Windows-specific APIs for date/time functionality

### Development Dependencies
- Visual Basic 6.0 IDE (optional, for GUI development)
- Make utility for command-line builds

## Version Control

### Git Guidelines
- Commit messages should describe VB6-specific changes
- Include both .vbp and source files in commits
- Build outputs are excluded via .gitignore

### File Types to Track
- `.vbp` - Project file
- `.frm` - Form files
- `.cls` - Class files
- `.bas` - Module files
- `.frx` - Form binary resources (if any)

## Troubleshooting

### Common Issues
- **Build failures**: Check VB6 installation path in Makefile
- **Runtime errors**: Verify COM component availability
- **Missing references**: Update GuiApp.vbp with correct paths
- **32-bit compatibility**: VB6 applications are 32-bit only

### Legacy Considerations
- VB6 is a legacy technology with limited modern tooling
- Some Windows APIs may not be available on newer Windows versions
- Consider compatibility with target deployment environment

## Agent Instructions

When working in this codebase, agents should:

1. **Always verify VB6 compatibility** before implementing features
2. **Follow the existing code style** and naming conventions
3. **Use the custom error handling framework** (Ensure.bas) for new functionality
4. **Implement proper error handling** using the Ensure module patterns
5. **Reference existing patterns** from core modules like Arrays.cls and TextFileOutput.cls
6. **Document breaking changes** when updating APIs

This AGENTS.md file will be updated as the project evolves and new conventions are established.

## Code References

When referencing specific functions or pieces of code include the pattern `file_path:line_number` to allow the user to easily navigate to the source code location.

<example>
user: Where are errors from the client handled?
assistant: Clients are marked as failed in the `connectToServer` function in src/services/process.ts:712.
</example>