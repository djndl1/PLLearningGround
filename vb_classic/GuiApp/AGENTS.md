# AGENTS.md - VB6 Codebase Guidelines

This file provides guidelines for agentic coding assistants working in this Visual Basic 6 (VB6) codebase.

## Project Overview

This is a legacy Visual Basic 6 application that demonstrates various programming concepts including array manipulation, date/time handling, and custom error handling. The project includes both GUI components and utility modules.

## Build Commands

### Building or Testing the Project

The agent should never build or test this project automatically after editing code.

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
' Use custom error handling classes
Private Sub SomeMethod()
    On Error GoTo ErrorHandler
    ' Code here
    Exit Sub
ErrorHandler:
    ' Handle error using custom error handler
    m_asserter.HandleError Err.Number, Err.Description
End Sub
```

#### Comments and Documentation
- Use single quote comments for explanations
- Document public methods with purpose, arguments, and return values
- Keep comments focused and relevant
- Remove commented-out code before committing

#### Memory Management
- Set objects to `Nothing` when no longer needed
- Use `ReDim Preserve` for dynamic array resizing
- Properly manage COM object references

### Project-Specific Patterns

#### Test Framework Pattern
```vb
' Test classes follow this pattern
Public Sub Run(ByRef myasserter As Asserter)
    Set m_asserter = myasserter
    TestMethod1
    TestMethod2
End Sub

Private Sub TestMethod1()
    m_asserter.IsTrue condition, "TestClass.TestMethod1", "Description"
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
3. **Use the custom test framework** for new functionality
4. **Implement proper error handling** using the IErrorHandler pattern
5. **Test through the GUI interface** to ensure functionality
6. **Document breaking changes** when updating APIs

This AGENTS.md file will be updated as the project evolves and new conventions are established.