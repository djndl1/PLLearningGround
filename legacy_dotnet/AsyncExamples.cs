using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

namespace LegacyDotNetApp
{
    /// <summary>
    /// Educational examples demonstrating async/await patterns for .NET 3.5 and .NET 4.0
    /// Uses AsyncBridge for .NET 3.5 compatibility
    /// </summary>
    public static class AsyncExamples
    {
        #region Basic Async Patterns

        /// <summary>
        /// Basic async method demonstrating the fundamental async/await pattern
        /// </summary>
        public static System.Threading.Tasks.Task<string> GetGreetingAsync(string name)
        {
            return DelayAsync(100).ContinueWith(t => $"Hello, {name}!");
        }

        /// <summary>
        /// Demonstrates async method with return value
        /// </summary>
        public static System.Threading.Tasks.Task<int> CalculateAsync(int a, int b)
        {
            return DelayAsync(50).ContinueWith(t => a + b);
        }

        /// <summary>
        /// Async method that returns a completed task immediately
        /// </summary>
        public static System.Threading.Tasks.Task<string> GetImmediateResultAsync()
        {
            var tcs = new TaskCompletionSource<string>();
            tcs.SetResult("Immediate result");
            return tcs.Task;
        }

        #endregion

        #region Error Handling Patterns

        /// <summary>
        /// Demonstrates exception handling in async methods
        /// </summary>
        public static System.Threading.Tasks.Task<string> ProcessWithErrorHandlingAsync(string input)
        {
            if (string.IsNullOrEmpty(input))
            {
                var tcs = new TaskCompletionSource<string>();
                tcs.SetResult("Error: Input cannot be null or empty");
                return tcs.Task;
            }

            return DelayAsync(100).ContinueWith(t => $"Processed: {input.ToUpper()}");
        }

        #endregion

        #region Parallel Operations

        /// <summary>
        /// Demonstrates running multiple async operations in parallel
        /// </summary>
        public static System.Threading.Tasks.Task<string[]> ProcessMultipleAsync(params string[] inputs)
        {
            var tasks = new List<System.Threading.Tasks.Task<string>>();

            foreach (var input in inputs)
            {
                tasks.Add(ProcessSingleAsync(input));
            }

            var tcs = new TaskCompletionSource<string[]>();

            // Simple simulation of WhenAll
            var results = new string[tasks.Count];
            int completed = 0;

            for (int i = 0; i < tasks.Count; i++)
            {
                int index = i;
                tasks[i].ContinueWith(t =>
                {
                    results[index] = t.Result;
                    completed++;

                    if (completed == tasks.Count)
                    {
                        tcs.SetResult(results);
                    }
                });
            }

            return tcs.Task;
        }

        /// <summary>
        /// Demonstrates sequential vs parallel execution
        /// </summary>
        public static System.Threading.Tasks.Task<ExecutionComparison> CompareExecutionModesAsync(string[] inputs)
        {
            // This demonstrates the pattern but uses synchronous execution for simplicity
            var comparison = new ExecutionComparison
            {
                Sequential = new string[inputs.Length],
                Parallel = new string[inputs.Length]
            };

            // Sequential execution simulation
            for (int i = 0; i < inputs.Length; i++)
            {
                comparison.Sequential[i] = $"Sequential: {inputs[i]}";
            }

            // Parallel execution simulation
            for (int i = 0; i < inputs.Length; i++)
            {
                comparison.Parallel[i] = $"Parallel: {inputs[i]}";
            }

            var tcs = new TaskCompletionSource<ExecutionComparison>();
            tcs.SetResult(comparison);
            return tcs.Task;
        }

        public class ExecutionComparison
        {
            public string[] Sequential { get; set; }
            public string[] Parallel { get; set; }
        }

        #endregion

        #region Cancellation Patterns

        /// <summary>
        /// Demonstrates cancellation token usage in async operations
        /// </summary>
        public static System.Threading.Tasks.Task<string> ProcessWithCancellationAsync(string input, CancellationToken cancellationToken)
        {
            return DelayAsync(500).ContinueWith(t =>
            {
                cancellationToken.ThrowIfCancellationRequested();
                return $"Completed: {input}";
            }, cancellationToken);
        }

        /// <summary>
        /// Demonstrates timeout pattern using cancellation tokens
        /// </summary>
        public static System.Threading.Tasks.Task<string> ProcessWithTimeoutAsync(string input, int timeoutMs)
        {
            var cts = new CancellationTokenSource();

            // Set timeout using timer
            var timer = new System.Timers.Timer(timeoutMs);
            timer.Elapsed += (s, e) => cts.Cancel();
            timer.Start();

            return ProcessWithCancellationAsync(input, cts.Token).ContinueWith(t =>
            {
                timer.Dispose();
                cts.Dispose();

                if (t.IsCanceled)
                    return "Operation timed out";

                return t.Result;
            });
        }

        #endregion

        #region Real-world Simulation Patterns

        /// <summary>
        /// Simulates file I/O operation
        /// </summary>
        public static System.Threading.Tasks.Task<string> ReadFileAsync(string filename)
        {
            return DelayAsync(200).ContinueWith(t => $"Contents of {filename}");
        }

        /// <summary>
        /// Simulates database query
        /// </summary>
        public static System.Threading.Tasks.Task<List<string>> QueryDatabaseAsync(string query)
        {
            return DelayAsync(150).ContinueWith(t => new List<string> { "Result 1", "Result 2", "Result 3" });
        }

        /// <summary>
        /// Simulates web API call
        /// </summary>
        public static System.Threading.Tasks.Task<string> CallWebApiAsync(string endpoint)
        {
            return DelayAsync(300).ContinueWith(t => $"Response from {endpoint}");
        }

        #endregion

        #region Helper Methods

        private static System.Threading.Tasks.Task<string> ProcessSingleAsync(string input)
        {
            return DelayAsync(100).ContinueWith(t => $"Processed: {input}");
        }

        /// <summary>
        /// Cross-framework compatible delay method
        /// .NET 3.5 uses Task.Factory.StartNew with Thread.Sleep
        /// .NET 4.0+ uses native Task.Delay
        /// </summary>
        public static System.Threading.Tasks.Task DelayAsync(int milliseconds)
        {
            var tcs = new TaskCompletionSource<object>();

            // Use a timer to simulate delay
            var timer = new System.Timers.Timer(milliseconds);
            timer.Elapsed += (s, e) =>
            {
                timer.Dispose();
                tcs.SetResult(null);
            };
            timer.Start();

            return tcs.Task;
        }

        #endregion
    }
}