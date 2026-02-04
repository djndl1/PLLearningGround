using System;
using System.Threading;
using System.Threading.Tasks;
using NUnit.Framework;

namespace LegacyDotNetApp.Tests
{
    [TestFixture]
    public class NetAsyncTests
    {
        [Test]
        public void GetGreetingAsync_ReturnsExpectedResult()
        {
            // Arrange
            var expected = "Hello, World!";

            // Act
            var task = AsyncExamples.GetGreetingAsync("World");
            var result = task.Result;

            // Assert
            Assert.AreEqual(expected, result);
        }

        [Test]
        public void CalculateAsync_ReturnsCorrectSum()
        {
            // Arrange
            var expected = 8;

            // Act
            var task = AsyncExamples.CalculateAsync(5, 3);
            var result = task.Result;

            // Assert
            Assert.AreEqual(expected, result);
        }

        [Test]
        public void GetImmediateResultAsync_ReturnsImmediateResult()
        {
            // Act
            var task = AsyncExamples.GetImmediateResultAsync();
            var result = task.Result;

            // Assert
            Assert.IsNotNull(result);
            Assert.IsTrue(result.Contains("Immediate result"));
        }

        [Test]
        public void ProcessWithErrorHandlingAsync_EmptyInput_ReturnsErrorMessage()
        {
            // Arrange
            var expected = "Error: Input cannot be null or empty";

            // Act
            var task = AsyncExamples.ProcessWithErrorHandlingAsync("");
            var result = task.Result;

            // Assert
            Assert.AreEqual(expected, result);
        }

        [Test]
        public void ProcessWithErrorHandlingAsync_ValidInput_ReturnsProcessedResult()
        {
            // Arrange
            var input = "test";
            var expected = "Processed: TEST";

            // Act
            var task = AsyncExamples.ProcessWithErrorHandlingAsync(input);
            var result = task.Result;

            // Assert
            Assert.AreEqual(expected, result);
        }

        [Test]
        public void ProcessMultipleAsync_ReturnsAllResults()
        {
            // Arrange
            var inputs = new[] { "A", "B", "C" };

            // Act
            var task = AsyncExamples.ProcessMultipleAsync(inputs);
            var results = task.Result;

            // Assert
            Assert.AreEqual(inputs.Length, results.Length);
            for (int i = 0; i < inputs.Length; i++)
            {
                Assert.IsTrue(results[i].Contains(inputs[i]));
            }
        }

        [Test]
        public void ProcessWithCancellationAsync_CompletesSuccessfully()
        {
            // Arrange
            var input = "test";

            // Act
            var task = AsyncExamples.ProcessWithCancellationAsync(input, CancellationToken.None);
            var result = task.Result;

            // Assert
            Assert.IsTrue(result.Contains("Completed: "));
        }

        [Test]
        public void ProcessWithTimeoutAsync_ShortTimeout_CompletesSuccessfully()
        {
            // Arrange
            var input = "test";

            // Act
            var task = AsyncExamples.ProcessWithTimeoutAsync(input, 1000);
            var result = task.Result;

            // Assert
            Assert.IsTrue(result.Contains("Completed: ") || result.Contains("Operation timed out"));
        }

        [Test]
        public void ReadFileAsync_ReturnsFileContent()
        {
            // Arrange
            var filename = "test.txt";

            // Act
            var task = AsyncExamples.ReadFileAsync(filename);
            var result = task.Result;

            // Assert
            Assert.IsTrue(result.Contains(filename));
        }

        [Test]
        public void QueryDatabaseAsync_ReturnsResults()
        {
            // Act
            var task = AsyncExamples.QueryDatabaseAsync("SELECT * FROM Users");
            var results = task.Result;

            // Assert
            Assert.IsNotNull(results);
            Assert.Greater(results.Count, 0);
        }

        [Test]
        public void CallWebApiAsync_ReturnsResponse()
        {
            // Arrange
            var endpoint = "/api/data";

            // Act
            var task = AsyncExamples.CallWebApiAsync(endpoint);
            var result = task.Result;

            // Assert
            Assert.IsTrue(result.Contains(endpoint));
        }

        [Test]
        public void CompareExecutionModesAsync_ReturnsComparison()
        {
            // Arrange
            var inputs = new[] { "X", "Y", "Z" };

            // Act
            var task = AsyncExamples.CompareExecutionModesAsync(inputs);
            var comparison = task.Result;

            // Assert
            Assert.IsNotNull(comparison);
            Assert.IsNotNull(comparison.Sequential);
            Assert.IsNotNull(comparison.Parallel);
            Assert.AreEqual(inputs.Length, comparison.Sequential.Length);
            Assert.AreEqual(inputs.Length, comparison.Parallel.Length);
        }
    }
}