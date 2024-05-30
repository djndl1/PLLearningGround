using System;
using System.Threading.Tasks;
using System.Collections.Generic;
using System.IO;
using System.Linq;

namespace msbuild_csharp
{
    class InitExample
    {
        public int Member { get; init; }
    }

    class Program
    {
        static int Main(string[] args)
        {
            Console.WriteLine(string.Concat(new string[] { "Test", " Test" }));
            var (a, b) = (2, 2);

            InitExample eg = new InitExample { Member = 5 };

            return 0;
        }
    }
}