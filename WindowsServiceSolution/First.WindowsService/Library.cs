using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;

namespace First.WindowsService
{
    public static class Library
    {
        public static void Write(string message)
        {
            var streamWriter = new StreamWriter(AppDomain.CurrentDomain.BaseDirectory + "\\Test.txt", true);
            streamWriter.Write(DateTime.UtcNow.ToString() + ":" + message);
            streamWriter.Flush();
            streamWriter.Close();
        }
    }
}
