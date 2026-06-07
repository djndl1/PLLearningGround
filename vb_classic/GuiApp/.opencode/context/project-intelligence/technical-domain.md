<!-- Context: project-intelligence/technical | Priority: critical | Version: 1.0 | Updated: 2026-06-07 -->

# Technical Domain

**Purpose**: VB6 ActiveX DLL patterns. The center of this file is the `Attribute VB_Description` documentation standard.
**Last Updated**: 2026-06-07

## Quick Reference
**Update Triggers**: New public member added | New class created | Documentation standard evolves
**Audience**: Developers writing VB6 in `LegacyApp.VB6/`

## Primary Stack
| Layer | Technology | Version | Rationale |
|-------|-----------|---------|-----------|
| Language | Visual Basic 6.0 | 6.0 | Legacy platform per AGENTS.md |
| Compile Target | ActiveX DLL | COM | Per AGENTS.md — `LegacyAppVB6.vbp` |
| Reference Submodule | .NET | - | `LegacyApp.DotNet/` — read-only, NOT for VB6 dev |
| Build Host | Windows + VB6 IDE | - | Cannot build on Android/Linux |

## Attribute VB_Description Standard
**Location**: line immediately after the signature. No blank line, no comment between.
**Format**: single physical line; line breaks within the string use the `\r\n` literal (CRLF, never `\n` alone).
**Quote**: double-quoted value.
**File line endings**: CRLF (matches the embedded `\r\n`).

### Structure (sections in fixed order, separated by `\r\n`)
- **Summary**: 1 line, ends with period. Imperative or descriptive.
- **Raises** *(optional)*: `Raises:\r\n  Code (Long): when condition` — when the method can `Err.Raise`.
- **Args** *(optional)*: `Args:\r\n  name (Type): description` — one entry per parameter, in declaration order.
- **Returns** *(optional)*: `Returns:\r\n  Type: description` — for `Function`s, omit for `Sub`s.

### Indent and format
- 2 spaces for items inside `Raises:` / `Args:` / `Returns:`.
- Arg format: `name (Type): description` — name MUST match the parameter name (casing too).
- Return format: `Type: description` (e.g. `Long: The days component.`).
- Array types use parens: `Byte()`, `Variant()`. UDTs use bare type name: `TimeSpan`.
- Trailing periods inside entries: not required (allowed).
- Blank line (`\r\n\r\n`) between summary and the next section: not currently applied across the codebase, but the forming standard is to include it.

### Example (verbatim, from `CTimeSpans.cls:272-273`)
```vb
Public Function TimeSpanFromHours(ByVal hours As Double) As TimeSpan
Attribute TimeSpanFromHours.VB_Description = "Returns a UDT TimeSpan representing the given number of hours.\r\nRaises Overflow on out-of-range.\r\nArgs:\r\n  hours (Double): The number of hours.\r\nReturns:\r\n  TimeSpan: The new UDT."
    Dim ticks As Variant
    ...
```

### Pre-signature `'` comments
Optional. When present, they duplicate the attribute content (pattern in `Ensure.cls`, `BigEndianConverter.cls`, `MinMax.cls`, `Numerics.cls`, `CTimeSpan.cls`). When absent, the attribute alone carries the doc (pattern in `CSlice.cls`, `CTimeSpanFactory.cls`, `CSliceFactory.cls`). Pick one style per file. The attribute is the source of truth for COM consumers; the `'` comments aid human readers in the IDE.

## Class Structure Patterns
**Value-type pair (e.g. `CTimeSpan` + `CTimeSpanFactory`)**:
- Instance class: `VB_Creatable=False, VB_PredeclaredId=False` (PublicNotCreatable). Storage in a `m_udt` UDT or `m_x` Variant. `Friend Sub Init(...)` as the internal constructor. `Friend Property Get Udt()` for cross-instance access.
- Factory class: `VB_Creatable=True, VB_PredeclaredId=False` (user must `New` it). Holds cached singletons (`Zero`/`MaxValue`/`MinValue`) with lazy-init.
- Procedural companion (e.g. `CTimeSpans`): `VB_GlobalNameSpace=True, VB_PredeclaredId=True` (singleton class with predeclared instance). Operates on UDTs. The OOP delegators call the procedural functions.

**Singleton utility class (e.g. `Ensure`, `Arrays`)**:
- `VB_GlobalNameSpace=True, VB_PredeclaredId=True, VB_Creatable=True, VB_Exposed=True`.
- All members are `Public Sub` / `Public Function` / `Public Property Get`. No instance state.

**Per-instance wrapper (e.g. `FileTimeDateTime`)**:
- `VB_Creatable=False, VB_PredeclaredId=False`. Construction only via factory (`FileTimeDateTimeFactory`).
- Mutating methods (`Init*`) are `Friend Sub`. Public surface is read-only + factory-built instances.

## Naming Conventions
| Type | Convention | Example |
|------|-----------|---------|
| Files | PascalCase + ext matching class | `CTimeSpan.cls`, `TimeSpanValues.bas` |
| Classes | PascalCase | `CTimeSpan`, `CTimeSpans` |
| Factory classes | PascalCase + `Factory` suffix | `CTimeSpanFactory`, `FileTimeDateTimeFactory` |
| Methods / Properties | PascalCase | `TimeSpanFromDays`, `GetArrayLength` |
| Private fields | `m_` prefix + PascalCase | `m_ticks`, `m_slice`, `m_udt` |
| Constants | `ALL_CAPS_SNAKE` | `MAX_TICKS_STR`, `MIN_TICKS_STR` |
| UDTs (`Public Type`) | PascalCase | `TimeSpan`, `LARGE_INTEGER` |
| Enum members | PascalCase under `PascalCase` enum | `ErrorCodes.Overflow` |

## Code Standards
- 4-space indentation (no tabs). Line continuations with ` _`.
- `Option Explicit` mandatory at top of every file.
- Private fields prefixed with `m_`. Constants `ALL_CAPS_SNAKE`.
- All public members carry `Attribute VB_Description` (this is the documented standard above).
- Use `Ensure` module for parameter validation with descriptive message arguments.
- Use `Arrays` module (singleton) for array operations.
- Use `ByRef` for UDT/UDT-array params (avoid Variant copy on hot paths).
- Use `CDec(literal_string)` and `CDec(string)` for large integer arithmetic (Long is 32-bit; Decimal/Variant carries Int64).
- Public Type / Public Const / Declare: legal only in `.bas` modules, NOT in class modules (object modules).
- Do not run build or test commands without explicit user instruction (Windows-only VB6 — AGENTS.md critical rule).
- When referencing code, include `file:line` (e.g. `Arrays.cls:25`).

## Security Requirements
N/A — desktop application with no network/IO attack surface in the documented modules.
COM exposure is controlled via `Attribute VB_Exposed` (only `True` for classes meant to be COM-visible).

## 📂 Codebase References
**Files with full `Attribute VB_Description` coverage** (the de facto pattern sources):
- `LegacyApp.VB6/CTimeSpans.cls` — 66 attributes (pre-signature comments + attribute, includes `Raises:`)
- `LegacyApp.VB6/CTimeSpan.cls` — 31 attributes (pre-signature comments + attribute)
- `LegacyApp.VB6/Numerics.cls` — 17 attributes (pre-signature comments + attribute, includes `VariantPair` Returns)
- `LegacyApp.VB6/Ensure.cls` — 17 attributes (pre-signature comments + attribute, long single-line args)
- `LegacyApp.VB6/CSlice.cls` — 16 attributes (attribute-only style, cleaner)
- `LegacyApp.VB6/CTimeSpanFactory.cls` — 14 attributes (attribute-only style)
- `LegacyApp.VB6/MinMax.cls` — 11 attributes (pre-signature comments + attribute)
- `LegacyApp.VB6/Numerics/BigEndianConverter.cls` — 8 attributes (pre-signature comments + attribute, `Byte()` Returns)
- `LegacyApp.VB6/Numerics/NativeConverter.cls` — 12 attributes
- `LegacyApp.VB6/Numerics/LittleEndianConverter.cls` — 8 attributes
- `LegacyApp.VB6/Numerics/BitReinterpret.cls` — 2 attributes
- `LegacyApp.VB6/CSliceFactory.cls` — 4 attributes (attribute-only style)

**Project rules**:
- `LegacyApp.VB6/AGENTS.md` — naming, error handling, build commands, "no auto-build" rule
- `LegacyApp.VB6/LegacyAppVB6.vbp` — project file, class/module ordering

## Related Files
- `LegacyApp.VB6/AGENTS.md` — project guidelines, code style, build commands
- `LegacyApp.VB6/LegacyAppVB6.vbp` — project file
- `LegacyApp.DotNet/` — .NET reference submodule (NOT for VB6 development)
