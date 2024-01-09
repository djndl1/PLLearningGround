.assembly extern mscorlib {}
.assembly ControlFlow {}

.module ControlFlow

.method static int32 Main(string[] args)
{
    .entrypoint
    .maxstack 8

    .locals init(
        bool zeroLen,
        int32 argLen)

    // read and save length
    ldarg args
    ldlen
    stloc argLen

    // compare and save result
    ldloc argLen
    ldc.i4.0
    ceq
    stloc zeroLen

    // check whether to return
    ldloc zeroLen
    brtrue.s RET_LEN // branch on true

    // else display length
    ldstr "Arg.Length {0}"
    ldloc argLen
    box int32
    call string [mscorlib]System.String::Format(string, object)
    call void [mscorlib]System.Console::WriteLine(string)

RET_LEN:
    ldloc argLen
    ret
}
