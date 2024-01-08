using System;

public static class Program
{
    public static void Main()
    {
        try
        {
            int.Parse("Invalid Number");
        }
        catch (FormatException ex)
        {
            Console.WriteLine(ex.Message);
        }
        finally
        {
            Console.WriteLine("Cleaning up");
        }
    }
}