.assembly extern mscorlib {}
.assembly CastConversion

.module CastConversion

.method static int32 Main()
{
    .entrypoint
    .maxstack 8

    .locals init (int32 small,
        int64 big)

    ldc.i4.s 123
    stloc small

    // conversions are required before assigning to another type
    ldloc small
    conv.i8 // cast to i8
    stloc big

    ldloc big
    conv.i4 // cast it i4
    stloc small
}
