using System;
using NUnit.Framework;
using System.Linq;
using System.Text.Json;

namespace csharpPlayground
{
    [TestFixture]
    public class EnumTest
    {
        [Test]
        public void GetAllValueStrings()
        {
            var valStrings = Enum.GetValues(typeof(DayOfWeek)).Cast<DayOfWeek>()
                .Select(e => e.ToString("d"));

            TestContext.Progress.WriteLine(
                JsonSerializer.Serialize(valStrings)
            );
        }

        [Test]
        public void IntegralConversion()
        {
            DayOfWeek e = (DayOfWeek)11;
            Assert.That((int)e, Is.EqualTo(11));
        }
    }
}
