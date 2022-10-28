using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace csharpPlayground
{
    public static class TestEnvironment
    {
        public static void WaitForDebugger()
        {
            do
            {
                Thread.Sleep(1000);
            } while (!Debugger.IsAttached);
        }
    }
}