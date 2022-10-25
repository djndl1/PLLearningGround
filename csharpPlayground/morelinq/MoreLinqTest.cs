using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using NUnit.Framework;
using System.Collections.Immutable;
using MoreLinq;


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
    }
}