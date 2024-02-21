using System;
using System.Collections.Generic;
using System.Linq;

using NUnit.Framework;

namespace csharpPlayground
{
    [TestFixture]
    public class LoopVarClosureTest
    {
        [Test]
        ///<summary>
        /// This returns 11
        ///</summary>
        public void ForLoopClosureTest()
        {
            List<Action> actions = new();
            List<int> results = new();
            for (int i = 0; i <= 10; i++)
            {
                actions.Add(() => results.Add(i));
            }

            actions.ForEach(a => a());

            Assert.AreEqual(11, results.Count);
            Assert.That(results, Is.All.EqualTo(11));
        }

        [Test]
        ///<summary>
        /// this prints
        ///</summary>
        public void ForeachLoopClosureTest()
        {
            List<Action> actions = new();
            List<int> results = new();
            foreach (int i in Enumerable.Range(0, 10))
            {
                actions.Add(() => results.Add(i));
            }

            actions.ForEach(a => a());
            Assert.True(Enumerable.Range(0, 10).ToList().SequenceEqual(results));
        }
    }
}