using System;

static class Program
{
    public static int Main(string[] args)
    {
        if (args.Length == 0)
        {
            return 0;
        }
        Console.WriteLine($"Args.Length {args.Length}");

        return args.Length;
    }
}