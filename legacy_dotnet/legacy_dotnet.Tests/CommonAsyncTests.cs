using System;
using System.Threading;
using NUnit.Framework;

namespace LegacyDotNetApp.Tests
{
    [TestFixture]
    public class CommonAsyncTests
    {
        [Test]
        public void DelayAsync_CompletesSuccessfully()
        {
            // Arrange
            var delayMs = 50;

            // Act
            var task = AsyncExamples.DelayAsync(delayMs);
            var startTime = DateTime.Now;
            task.Wait();
            var elapsed = DateTime.Now - startTime;

            // Assert
            Assert.IsTrue(task.IsCompleted);
            Assert.IsTrue(elapsed.TotalMilliseconds >= delayMs - 10); // Allow small tolerance
        }

        [Test]
        public void AsyncMethods_ReturnCompletedTasks()
        {
            // Test that all async methods return non-null tasks
            var tasks = new System.Threading.Tasks.Task[]
            {
                AsyncExamples.GetGreetingAsync("Test"),
                AsyncExamples.CalculateAsync(1, 2),
                AsyncExamples.GetImmediateResultAsync(),
                AsyncExamples.ProcessWithErrorHandlingAsync("test"),
                AsyncExamples.ReadFileAsync("test.txt"),
                AsyncExamples.QueryDatabaseAsync("test"),
                AsyncExamples.CallWebApiAsync("test")
            };

            foreach (var task in tasks)
            {
                Assert.IsNotNull(task);
                Assert.IsFalse(task.IsFaulted);
            }
        }

        [Test]
        public void ProcessWithCancellationAsync_CancelledToken_ThrowsOperationCanceledException()
        {
            // Arrange
            var cts = new CancellationTokenSource();
            cts.Cancel();

            // Act & Assert
            var task = AsyncExamples.ProcessWithCancellationAsync("test", cts.Token);
            Assert.Throws<AggregateException>(() => task.Wait());
        }

        [Test]
        public void FrameworkDetection_WorksCorrectly()
        {
            // This test should work on both frameworks
            var isNet35 = IsNet35();
            var isNet40 = IsNet40();

            // One should be true, the other false
            Assert.IsTrue(isNet35 || isNet40);
            Assert.IsFalse(isNet35 && isNet40);
        }

        private bool IsNet35()
        {
#if NET35
            return true;
#else
            return false;
#endif
        }

        private bool IsNet40()
        {
#if NET40
            return true;
#else
            return false;
#endif
        }
    }
}