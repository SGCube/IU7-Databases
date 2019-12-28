using System;
using System.Collections.Generic;
using System.Linq;
using System.Xml.Linq;
using System.Text;
using System.Threading.Tasks;

namespace task02_LINQtoXML
{
    class Program
    {
        static void Main(string[] args)
        {
            char choice = '\0';
            do
            {
                Console.WriteLine("Выберите запрос:\n" +
                    "1. Чтение из XML документа.\n" +
                    "2. Вывести первый элемент.\n" +
                    "3. Обновление XML документа.\n" +
                    "4. Запись в XML документ\n" +
                    "Иначе - Завершение\n");
                Console.WriteLine("Введите код запроса: ");
                choice = Convert.ToChar(Console.ReadLine());
                switch (choice)
                {
                    case '1':
                        ReadXML();
                        break;
                    case '2':
                        ReadOneFromXML();
                        break;
                    case '3':
                        UpdateXML();
                        break;
                    case '4':
                        WriteXML();
                        break;
                    default:
                        choice = '\0';
                        break;
                }
            }
            while (choice != '\0');
        }

        static void ReadXML()
        {
            XDocument xdoc = XDocument.Load(@"../../../data.xml");
            var result = from w in xdoc.Descendants("Workers")
                         select w;

            Console.WriteLine();
            foreach (var grp in result)
            {
                Console.WriteLine("{0}, {1}, {2}",
                    grp.Element("Name").Value, grp.Element("Job").Value,
                    grp.Element("Phone_Number").Value);
            }
            Console.WriteLine();
        }

        static void ReadOneFromXML()
        {
            XDocument xdoc = XDocument.Load(@"../../../data.xml");
            XElement grp = xdoc.Element("ROOT").Element("Workers");

            Console.WriteLine("{0}, {1}, {2}",
                    grp.Element("Name").Value, grp.Element("Job").Value,
                    grp.Element("Phone_Number").Value);
            Console.WriteLine();
        }

        static void UpdateXML()
        {
            XDocument xdoc = XDocument.Load(@"../../../data.xml");
            IEnumerable<XElement> elements = xdoc.Descendants("Workers");

            Console.WriteLine("Введите ID записи: ");
            var id = Convert.ToInt32(Console.ReadLine()) - 1;

            XElement toChange = elements.ElementAtOrDefault(id);

            Console.WriteLine("\nИзмененный элемент до:");
            Console.WriteLine("{0}, {1}, {2}",
                    toChange.Element("Name").Value, toChange.Element("Job").Value,
                    toChange.Element("Phone_Number").Value);
            Console.WriteLine();

            toChange.SetElementValue("Phone_Number", "+79150000000");
            xdoc.Save("../../../data.xml");

            Console.WriteLine("Измененный элемент после:");
            Console.WriteLine("{0}, {1}, {2}",
                    toChange.Element("Name").Value, toChange.Element("Job").Value,
                    toChange.Element("Phone_Number").Value);
            Console.WriteLine();
        }

        static void WriteXML()
        {
            XDocument xdoc = XDocument.Load(@"../../../data.xml");

            Console.WriteLine("Введите имя: ");
            var _name = Console.ReadLine();
            Console.WriteLine("Введите должность: ");
            var _job = Console.ReadLine();
            Console.WriteLine("Введите номер телефона: ");
            var _phone = Console.ReadLine();

            XElement worker = new XElement("Workers");
            XElement name = new XElement("Name", _name);
            XElement job = new XElement("Job", _job);
            XElement phone_number = new XElement("Phone_Number", _phone);


            Console.WriteLine("\nЗапись добавлена");

            worker.Add(name, job, phone_number);
            xdoc.Element("ROOT").Add(worker);
            xdoc.Save("../../../data.xml");
        }
    }
}
