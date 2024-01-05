.assembly extern mscorlib {}
.assembly Adder {}

.module Adder

.method static int32 Main()
{
    .entrypoint // mark as entrypoint
    .maxstack 4 // use 4 stack slots

    // declare 3 variables
    .locals init (int32 first,
                  int32 second,
                  int32 result)

    ldstr "First Number: "
    call void [mscorlib] System.Console::Write(string)

    // read the first number
    call string [mscorlib] System.Console::ReadLine()
    call int32 [mscorlib] System.Int32::Parse(string)
    // store the returned stack value to first variable
    stloc first

    ldstr "Second Number: "
    call void [mscorlib] System.Console::Write(string)
    call string [mscorlib] System.Console::ReadLine()
    call int32 [mscorlib] System.Int32::Parse(string)
    stloc second

    // push the two operands onto the stack
    ldloc first
    ldloc second
    add // add the two numbers
    stloc result // pop the result into the result variable

    // call WriteLine with format string
    ldstr "{0} + {1} = {2}"

    ldloc first
    box int32

    ldloc second
    box int32

    ldloc result
    box int32
    call void [mscorlib]System.Console::WriteLine(string, object, object, object)

    ldloc result
    ret
}
