.assembly extern mscorlib {}
.assembly ControlFlow {}

.module ControlFlow

.method static int32 Main(string[] args)
{
    .entrypoint
    .maxstack 8

    .locals init(
        bool zeroLen,
        int32 argLen,
	int32 idx,
	int32 sum)

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

INIT_LOOP:
    ldc.i4.0
    stloc idx
    ldc.i4.0
    stloc sum
LOOP_CONDITION:
    ldloc idx
    ldloc argLen
    ceq

    brtrue.s LOOP_END
SUM_LOOP:
    ldloc sum
    ldloc idx
    add
    stloc sum
POST_EXPR:
    ldc.i4.1
    ldloc idx
    add
    stloc idx
    br.s LOOP_CONDITION
LOOP_END:
    ldstr "Sum: {0}"
    ldloc sum
    box int32
    call void [mscorlib]System.Console::WriteLine(string, object)

RET_LEN:
    ldloc argLen
    ret
}
