using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using NUnit.Framework;
using System.Collections.Immutable;
using MoreLinq;
using System.Text.Json;
using NUnit.Framework.Internal;

namespace csharpPlayground.morelinq
{
    public class MoreLinqTest
    {
        private IEnumerable<string>? Fruits;

        [SetUp]
        public void Setup()
        {
            Fruits = new List<string>
            {
                "apple",
                "banana",
                "plum",
                "raspberry",
                "strawberry",
                "pear",
                ""
            }.ToImmutableArray();
        }

        [Test]
        public void TestAggregate()
        {
            (string concated, string longest) = Fruits.Aggregate("", (a, b) => $"{a}-{b}",
                "", (a, b) => ((a?.Length ?? 0) > (b?.Length ?? 0) ? a : b) ?? "",
                (a1, a2) => (a1, a2));

            Assert.That(concated, Is.EqualTo("-apple-banana-plum-raspberry-strawberry-pear-"));
            Assert.That(longest, Is.EqualTo("strawberry"));
        }

        [Test]
        public void TestAggregateRight()
        {
            string concated = Fruits.AggregateRight("", (a, b) => $"{a}-{b}");

            Assert.That(concated, Is.EqualTo("apple-banana-plum-raspberry-strawberry-pear--"));
        }

        [Test]
        public void TestAssertCount()
        {
            Fruits.AssertCount(7);
        }

        [Test]
        public void TestChoose()
        {
            var chosen = Fruits.Choose(f => (f.Length > 5, f)).ToList();

            TestContext.Progress.WriteLine(JsonSerializer.Serialize(chosen, new JsonSerializerOptions
            {
                WriteIndented = true
            }));
        }

        [Test]
        public void TestBatch()
        {
            foreach (var batch in Fruits.Batch(2))
            {
                Assert.That(batch.Count(), Is.LessThanOrEqualTo(2));
            }
        }

        [Test]
        public void TestSlice()
        {
            var rng = Fruits.ToList().GetRange(2, 2);
            Assert.That(Fruits.Slice(2, 2), Is.EquivalentTo(rng));
        }

        [Test]
        public void TestIndex()
        {
            foreach (var kv in Fruits.Index(2))
            {
                TestContext.Progress.WriteLine($"[{kv.Key} => {kv.Value}]");
            }
        }

        [Test]
        public void TestCountdown()
        {
            foreach (var cd in Fruits.CountDown(3, (a, i) => (i, a)))
            {
                TestContext.Progress.WriteLine(cd);
            }
        }
    }
}