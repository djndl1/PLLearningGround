# AGENTS.md - VB6 Codebase Guidelines

This file provides guidelines for agentic coding assistants working in this Visual Basic 6 (VB6) codebase.

## Project Overview

This repository contains a legacy Visual Basic 6 application with a multi-component architecture:

### Main VB6 Application
- **Primary project**: GUI application demonstrating various programming concepts including array manipulation, date/time handling, and custom error handling
- **Components**: GUI forms, utility modules, and custom error handling classes

### LegacyApp.VB6 Subproject
- **VB6 ActiveX DLL**: Utility library (`LegacyAppVB6.vbp`) containing classes for arrays, date/time handling, file operations, and error validation
- **.NET Infrastructure**: Cross-platform utility library (`LegacyApp/`) with data access, GUI utilities, and testing frameworks

## Project Structure

```
GuiApp/
├── LegacyApp.VB6/           # Subproject directory
│   ├── LegacyAppVB6.vbp     # VB6 ActiveX DLL project
│   ├── Arrays.cls           # Array manipulation utilities
│   ├── Ensure.cls           # Error validation and assertions
│   ├── TextFileOutput.cls   # File I/O operations
│   ├── build/               # Compiled VB6 DLL outputs
│   └── LegacyApp/           # .NET infrastructure solution
│       ├── Infrastructure/  # Core utilities and data access
│       ├── Gui/             # WinForms utilities
│       ├── Test/            # NUnit test projects
│       └── LegacyApp.sln    # .NET solution file
└── [Main VB6 project files]
```

## Build Commands

### Building the Project

**Windows-only build environment required** - This is a legacy VB6 project that requires the Visual Basic 6.0 IDE for compilation.

Available build commands (for reference only - do not run automatically):

```bash
# Main GUI application
make build_GuiApp

# LegacyApp VB6 DLL
make -C LegacyApp.VB6 build_LegacyAppVB6

# Install DLL to system (requires admin privileges)
make -C LegacyApp.VB6 install
```

### Testing the Project

**No automated test framework** - Testing must be performed manually through the VB6 IDE or external test applications.

**IMPORTANT**: Agents should never attempt to build or test this project automatically after editing code.

**CRITICAL RULE**: Do not build or test this project automatically without explicit instructions from the user.

## Code Style Guidelines

### File Organization
- **File Structure**: Separate files for forms (.frm), classes (.cls), and modules (.bas)
- **Naming**: Files should match their primary class/module name
- **Build Output**: Compiled to `build/` directory

### LegacyApp.VB6 Subproject Structure
- **VB6 DLL**: ActiveX DLL project with utility classes for arrays, date/time, file operations
- **.NET Solution**: Multi-project solution with infrastructure, GUI, testing components
- **Cross-Platform**: Supports .NET Framework and .NET 8 targets

### Key Components
- **Main Application**: GUI application with test runner functionality (MainForm.frm)
- **Test Framework**: Custom test classes following Asserter pattern (ArraysTest.cls, CSliceTest.cls, etc.)
- **Utility Library**: LegacyAppVB6.dll containing core functionality
- **Error Handling**: Custom IErrorHandler interface and implementations

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

### Project-Specific Patterns

#### Test Framework Pattern
```vb
' Test classes follow this pattern (see ArraysTest.cls:18-21)
Public Sub Run(ByRef myasserter As Asserter)
    Set m_asserter = myasserter
    TestMethod1
    TestMethod2
End Sub

Private Sub TestMethod1()
    m_asserter.IsTrue condition, "TestClass.TestMethod1", "Description"
End Sub
```

#### Array Operations Pattern
```vb
' Use Arrays singleton class for array manipulation (see Arrays.cls:27-42)
Public Function GetArrayLength(ByRef arr As Variant) As Long
    GetArrayLength = UBound(arr) - LBound(arr) + 1
End Function

Public Sub ResizeArray(ByRef arr As Variant, ByVal newSize As Long)
    Dim l, u As Long
    l = LBound(arr)
    u = l + newSize - 1
    ReDim Preserve arr(u)
End Sub
```

#### Error Handler Pattern
```vb
' Custom error handlers implement IErrorHandler interface
Public Sub HandleError(ByVal errorCode As Long, ByVal errorDescription As String)
    ' Implementation
End Sub
```

## Development Workflow

### Adding New Features
1. Follow existing naming and coding conventions
2. Add appropriate error handling
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
7. **Use exact line references** when referring to code (e.g., `ArraysTest.cls:18-21`)
8. **Never attempt automated builds or tests** without explicit user instruction

## Code References

When referencing specific functions or pieces of code, include the pattern `file_path:line_number` to allow the user to easily navigate to the source code location.

<example>
user: Where are errors from the client handled?
assistant: Clients are marked as failed in the `connectToServer` function in src/services/process.ts:712.
</example>

This AGENTS.md file will be updated as the project evolves and new conventions are established.