.assembly extern mscorlib {}
.assembly HelloWorld {}


.module HelloWorld.exe
.method static void Main()
{
    .entrypoint
    .maxstack 1

    ldstr "Hello World!"
    call void [mscorlib]System.Console::WriteLine(string)

    ret
}
