using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.ServiceProcess;
using System.Text;
using System.Threading.Tasks;

namespace First.WindowsService
{
    static class Program
    {
        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        static void Main(string[] argList)
        {
            if (Debugger.IsAttached)
            {
                FirstService firstService = new FirstService();
                firstService.DirectStart();

                Console.WriteLine("Service running, press any key to stop");
                Console.ReadLine();
                Console.WriteLine("Stopping service...");
                firstService.DirectStop();
                Console.WriteLine("Service stopped.");
            }
            else
            {
                ServiceBase[] ServicesToRun;
                ServicesToRun = new ServiceBase[] 
                { 
                    new FirstService() 
                };
                ServiceBase.Run(ServicesToRun);
            }
        }
    }
}
