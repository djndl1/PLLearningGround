using System;
using System.Diagnostics;
using System.Threading;
using System.Threading.Tasks;

namespace LegacyDotNetApp
{
    /// <summary>
    /// Async entry point demonstrating async/await patterns for .NET 3.5 and .NET 4.0
    /// This provides an alternative to the synchronous Program.cs
    /// </summary>
    public static class AsyncProgram
    {
        /// <summary>
        /// Async entry point for .NET 4.0+ (C# 7.1+ async Main support)
        /// For .NET 3.5, we use a different approach since async Main isn't supported
        /// </summary>
#if NET40
        public static async System.Threading.Tasks.Task Main(string[] args)
        {
            await RunAsyncDemo();
        }
#else
        // .NET 3.5 doesn't support async Main, so we use a synchronous wrapper
        public static void Main(string[] args)
        {
            // Run async operations synchronously for .NET 3.5
            RunAsyncDemo().Wait();
        }
#endif

        /// <summary>
        /// Main async demonstration method
        /// </summary>
        private static async System.Threading.Tasks.Task RunAsyncDemo()
        {
            Console.WriteLine("=== Async Programming Demo ===");
            Console.WriteLine($"Running on: {(IsNet35() ? ".NET 3.5 with AsyncBridge" : ".NET 4.0+ with native async")}");
            Console.WriteLine();

            // Run demonstrations sequentially
            await DemonstrateBasicAsyncOperations()
                .ContinueWith(t1 => DemonstrateErrorHandling())
                .ContinueWith(t2 => DemonstrateParallelOperations())
                .ContinueWith(t3 => DemonstrateCancellationPatterns())
                .ContinueWith(t4 => DemonstrateRealWorldPatterns())
                .ContinueWith(t5 =>
                {
                    Console.WriteLine("\n=== Demo Completed ===");
                });
        }

        private static System.Threading.Tasks.Task DemonstrateBasicAsyncOperations()
        {
            Console.WriteLine("1. Basic Async Operations");
            Console.WriteLine("-".PadRight(40, '-'));

            return AsyncExamples.GetGreetingAsync("World")
                .ContinueWith(t1 =>
                {
                    Console.WriteLine($"Basic async: {t1.Result}");
                    return AsyncExamples.CalculateAsync(5, 3);
                })
                .Unwrap()
                .ContinueWith(t2 =>
                {
                    Console.WriteLine($"Async calculation: 5 + 3 = {t2.Result}");
                    return AsyncExamples.GetImmediateResultAsync();
                })
                .Unwrap()
                .ContinueWith(t3 =>
                {
                    Console.WriteLine($"Immediate result: {t3.Result}");
                    Console.WriteLine();
                });
        }

        private static System.Threading.Tasks.Task DemonstrateErrorHandling()
        {
            Console.WriteLine("2. Error Handling Patterns");
            Console.WriteLine("-".PadRight(40, '-'));

            return AsyncExamples.ProcessWithErrorHandlingAsync("")
                .ContinueWith(t1 =>
                {
                    Console.WriteLine($"Error handled: {t1.Result}");
                    return AsyncExamples.ProcessWithErrorHandlingAsync("test");
                })
                .Unwrap()
                .ContinueWith(t2 =>
                {
                    Console.WriteLine($"Success: {t2.Result}");
                    Console.WriteLine();
                });
        }

        private static System.Threading.Tasks.Task DemonstrateParallelOperations()
        {
            Console.WriteLine("3. Parallel Operations");
            Console.WriteLine("-".PadRight(40, '-'));

            var inputs = new[] { "A", "B", "C", "D" };

            return AsyncExamples.ProcessMultipleAsync(inputs)
                .ContinueWith(t1 =>
                {
                    Console.WriteLine($"Parallel results: {string.Join(", ", t1.Result)}");
                    return AsyncExamples.CompareExecutionModesAsync(new[] { "X", "Y", "Z" });
                })
                .Unwrap()
                .ContinueWith(t2 =>
                {
                    Console.WriteLine($"Sequential: {string.Join(", ", t2.Result.Sequential)}");
                    Console.WriteLine($"Parallel: {string.Join(", ", t2.Result.Parallel)}");
                    Console.WriteLine();
                });
        }

        private static System.Threading.Tasks.Task DemonstrateCancellationPatterns()
        {
            Console.WriteLine("4. Cancellation Patterns");
            Console.WriteLine("-".PadRight(40, '-'));

            // Normal operation without cancellation
            return AsyncExamples.ProcessWithCancellationAsync("normal", CancellationToken.None)
                .ContinueWith(t1 =>
                {
                    Console.WriteLine($"Normal operation: {t1.Result}");
                    return AsyncExamples.ProcessWithTimeoutAsync("timeout", 300);
                })
                .Unwrap()
                .ContinueWith(t2 =>
                {
                    Console.WriteLine($"With timeout: {t2.Result}");
                    Console.WriteLine();
                });
        }

        private static System.Threading.Tasks.Task DemonstrateRealWorldPatterns()
        {
            Console.WriteLine("5. Real-world Simulations");
            Console.WriteLine("-".PadRight(40, '-'));

            return AsyncExamples.ReadFileAsync("example.txt")
                .ContinueWith(t1 =>
                {
                    Console.WriteLine($"File read: {t1.Result}");
                    return AsyncExamples.QueryDatabaseAsync("SELECT * FROM Users");
                })
                .Unwrap()
                .ContinueWith(t2 =>
                {
                    Console.WriteLine($"Database results: {string.Join(", ", t2.Result.ToArray())}");
                    return AsyncExamples.CallWebApiAsync("/api/data");
                })
                .ContinueWith(t3 =>
                {
                    Console.WriteLine($"API response: {t3.Result}");
                    Console.WriteLine();
                });
        }

        /// <summary>
        /// Helper method to determine current framework
        /// </summary>
        private static bool IsNet35()
        {
#if NET35
            return true;
#else
            return false;
#endif
        }
    }
}