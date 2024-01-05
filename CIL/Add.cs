using System;

static class Adder
{
    public static int Main()
    {
        int first = 0;
        int second = 0;
        int result = 0;

        Console.Write("First Number");
        first = int.Parse(Console.ReadLine());

        Console.Write("Second Number");
        second = int.Parse(Console.ReadLine());

        result = first + second;

        Console.WriteLine("{0} + {1} = {2}", first, second, result);

        return result;
    }
}