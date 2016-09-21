using First.WindowClassLibrary;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.Objects;
using System.Diagnostics;
using System.Linq;
using System.ServiceProcess;
using System.Text;
using System.Threading.Tasks;
using System.Timers;

namespace First.WindowsService
{
    partial class FirstService : ServiceBase
    {
        private Timer _T = null;
        private PumpEntities _Entities;
        public FirstService()
        {
            InitializeComponent();
            _Entities = new PumpEntities();
        }

        public void DirectStart()
        {
            OnStart(new string[0]);
        }

        protected override void OnStart(string[] args)
        {
            _T = new Timer();
            this._T.Interval = 1000;
            this._T.Elapsed += _T_Elapsed;
            this._T.Enabled = true;
            //Library.Write("Service start\n");
            Console.WriteLine("Service start");
            // TODO: Add code here to start your service.
        }

        void _T_Elapsed(object sender, ElapsedEventArgs e)
        {
            var nextId = new ObjectParameter("NextId", typeof(Guid));
            var result = _Entities.DequePending(nextId);
            if (!(nextId.Value is System.DBNull))
            {
                Console.WriteLine((Guid)nextId.Value);
            }
            else
            {
                Console.WriteLine("Guid not found");
            }
            //Library.Write("Service inprocess successfully\n");
        }

        public void DirectStop()
        {
            OnStop();
        }

        protected override void OnStop()
        {
            //Library.Write("Service end\n");
            Console.WriteLine("Service end");
            this._T.Enabled = false;
        }
    }
}
