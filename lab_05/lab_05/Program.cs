using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using System.Xml;
using System.Xml.Linq;
using System.Xml.Schema;

namespace lab_05
{
    class Program
    {
        static void Main(string[] args)
        {
            XmlSchemaSet schemas = new XmlSchemaSet();
            schemas.Add("", "../../../task3.xsd");

            XDocument custOrdDoc = XDocument.Load("../../../task2.xml");
            bool errors = false;
            custOrdDoc.Validate(schemas, (o, e) =>
            {
                Console.WriteLine(e.Message);
                errors = true;
            });
            Console.WriteLine("Group {0}", errors ? "did not pass validation" : "passed validation");

            Console.ReadLine();
        }
    }
}
