.assembly extern mscorlib {}
.assembly CustomTypes {}

.module CustomTypes

.namespace Custom.Types
{
    // called class but actually should be .type
    // there is no namespace, rather part of a type name
    .class public interface IHouse
    {
        // members
    }


    .class public House // by default inherits System.Object if not specified
    extends [mscorlib]System.Object
    implements Custom.Types.IHouse
    {
        .method public virtual void ShowHouseType()
        {
            .maxstack 1
            ldstr "Custom.Types.House (CIL version)"
            call void [mscorlib]System.Console::WriteLine(string)

            ret
        }

        // instance attribute may be omitted
        .method public instance void Display()
        {
            .maxstack 1

            ldstr "Displaying Custom.Types.House (CIL version)"
            call void [mscorlib]System.Console::WriteLine(string)

            ret
        }

        // type initializer/static constructor
        .method static void .cctor()
        {
            .maxstack 1

            ldstr "Initializing the Custom.Types.House Type (CIL version)"
            call void [mscorlib]System.Console::WriteLine(string)

            ret
        }

        // instance initializer/constructors must be explicitly defined
        .method public void .ctor()
        {
            .maxstack 1

            ldarg.0 // push this instance onto the stack
            // call a instance metho
            call instance void [mscorlib]System.Object::.ctor()

            ldstr "Creating a Custom.Types.House Instance"
            call void [mscorlib]System.Console::WriteLine(string)

            ret
        }
    }

    .class public SpecialHouse
    extends Custom.Types.House
    implements Custom.Types.IHouse
    {
        .method public void .ctor()
        {
            .maxstack 1

            ldarg.0 // push this instance onto the stack
            // call a instance metho
            call instance void Custom.Types.House::.ctor()

            ldstr "Creating a Custom.Types.SpecialHouse Instance"
            call void [mscorlib]System.Console::WriteLine(string)

            ret
        }

        .method public virtual void ShowHouseType()
        {
            .maxstack 1

            ldstr "Custom.Types.SpecialHouse (CIL version)"
            call void [mscorlib]System.Console::WriteLine(string)

            ret
        }
    }

    // a static class
    .class public abstract sealed Houses
    {
        /* members */
    }
}

.method static void Main()
{
    .entrypoint
    .maxstack 4

    .locals (class Custom.Types.House house,
        class Custom.Types.House specialHouse)

    // newobj memory allocated, fields initialized to their default values; initializer called
    newobj instance void Custom.Types.House::.ctor()
    stloc house

    ldloc house
    call instance void Custom.Types.House::Display()

    newobj instance void Custom.Types.SpecialHouse::.ctor()
    stloc specialHouse

    // call as a normal method
    ldloc specialHouse
    call instance void Custom.Types.House::ShowHouseType()

    // call as a virtual method and resolve the actual implementation
    ldloc specialHouse
    callvirt instance void Custom.Types.House::ShowHouseType()

    ret
}
