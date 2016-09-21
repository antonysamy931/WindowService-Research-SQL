using First.WindowClassLibrary;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace First.WindowClient
{
    class Program
    {
        static void Main(string[] args)
        {
            PumpEntities _Entities = new PumpEntities();
            Console.WriteLine("How many record want to insert?");
            int number = Convert.ToInt32(Console.Read());
            int i = 0;
            while (i < number)
            {
                var Id = Guid.NewGuid();
                _Entities.Pump_Tb.Add(new Pump_Tb()
                {
                    BrokerId = Id.ToString()
                });
                _Entities.SaveChanges();
                _Entities.EnquePending(DateTime.UtcNow, Id);
                i++;
            }
        }
    }
}
