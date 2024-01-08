.assembly extern mscorlib {}
.assembly Exception {}

.module Exception

// builtin support for try-catch-finally in CIL
.method static void Main()
{
    .entrypoint
    .maxstack 8

    // every try paired with a single handler
    .try
    {
        .try
        {
            .try
            {
                //ldstr "Parsing"
                //call void [mscorlib]System.Console::WriteLine(string)

                ldstr "Invalid number"
                call int32 [mscorlib]System.Int32::Parse(string)

                leave.s _inner// normal exit, otherwise there must be an exception thrown
            }
            // executed only on fault
            fault
            {
                ldstr "Faulted"
                call     void [mscorlib]System.Console::WriteLine(string)
                endfault
                // continues to another handler
            }
            _inner:
                leave.s _middle
        }
        catch class [mscorlib]System.FormatException
        {
            callvirt instance string [mscorlib]System.Exception::get_Message()
            call     void [mscorlib]System.Console::WriteLine(string)

            leave.s _middle
        }
        _middle:
            leave.s _outer
    }
    finally
    {
        // cleanup
        ldstr "Cleaning up"
        call     void [mscorlib]System.Console::WriteLine(string)

        endfinally
    }

_outer:
    ret
}
