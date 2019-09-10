using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;

namespace DotNetCoreAspNet
{
    public class Program
    {

       
        public static void Main(string[] args)
        {
            string EnvPort = Environment.GetEnvironmentVariable("Port") ?? "8080";
            CreateWebHostBuilder(args,EnvPort).Build().Run();
        }

        public static IWebHostBuilder CreateWebHostBuilder(string[] args, string EnvPort) =>
            WebHost.CreateDefaultBuilder(args)
                .UseUrls("http://0.0.0.0:"+EnvPort)
                .UseStartup<Startup>();
    }
}
