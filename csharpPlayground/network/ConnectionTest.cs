using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.Linq;
using System.Reflection;
using System.Text.Json;
using System.Threading.Tasks;
using System.Net.NetworkInformation;
using MoreLinq;
using NUnit.Framework;
using NUnit;
using System.Net.Sockets;

namespace csharpPlayground;

[TestFixture]
public class ConnectionTest
{
    [Test]
    public async Task SimplePing()
    {
        using var ping = new Ping();

        PingReply reply = await ping.SendPingAsync("10.10.0.3", 10_000);

        TestContext.Progress.WriteLine(reply.Status);
    }

    [Test]
    public async Task SimpleTcpTest()
    {
        using var tcpClient = new TcpClient();

        tcpClient.SendTimeout = 30000;
        try
        {
            await tcpClient.ConnectAsync("10.10.0.3", 1521);

            Assert.True(tcpClient.Connected);
        }
        catch (Exception e)
        {
            Assert.Fail("Failed to connect: " + e.Message);
        }
    }
}