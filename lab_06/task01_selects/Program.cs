using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace task01_selects
{
    class Program
    {
        static void Main(string[] args)
        {
            Department[] deps = {
                new Department(1, "IT"),
                new Department(2, "Бухгалтерия"),
                new Department(3, "Финансовый")
            };

            Worker[] workers = {
                new Worker(1, "Синицына Виктория Павловна", 21, 0, 1),
                new Worker(2, "Мартынова Марина Васильевна", 50, 20, 2),
                new Worker(3, "Игнатова Екатерина Юрьевна", 45, 15, 2),
                new Worker(4, "Григорьев Вадим Александрович", 50, 25, 3),
                new Worker(5, "Кудряшов Илья Константинович", 28, 5, 1),
                new Worker(6, "Ковалева Елена Владимировна", 25, 1, 1),
                new Worker(7, "Трофимов Павел Дмитриевич", 35, 5, 2),
                new Worker(8, "Тихонова Виктория Олеговна", 40, 12, 2),
                new Worker(9, "Туров Евгений Сергеевич", 27, 3, 3),
                new Worker(10, "Моисеев Григорий Валерьевич", 56, 28, 3)
            };

            // 1. where
            Console.WriteLine("\n1. where - сотрудники не старше 30 лет:\n");
            var result1 = from w in workers where w.age <= 30 select w;
            foreach (var grp in result1)
            {
                Console.WriteLine("{0},\tвозраст: {1}", grp.name, grp.age);
            }

            // 2. orderby
            Console.WriteLine("\n2. orderby - список сотрудников" +
                "в алфавитном порядке:\n");
            var result2 = from w in workers orderby w.name select w;
            foreach (var grp in result2)
            {
                Console.WriteLine("{0},\tвозраст: {1}", grp.name, grp.age);
            }

            // 3. join
            Console.WriteLine("\n3. join - список сотрудников с именем" +
                "их отдела:\n");
            var result3 = from w in workers join d in deps
                          on w.dep_id equals d.id
                          select new
                          { Name = w.name, Age = w.age, Dep = d.name };
            foreach (var grp in result3)
            {
                Console.WriteLine("{0},\tвозраст: {1},\tотдел: {2}",
                    grp.Name, grp.Age, grp.Dep);
            }

            // 4. group 
            Console.WriteLine("\n4. join - число сотрудников отделов:\n");
            var result4 = from w in workers group w by w.dep_id into gr
                          select new { Dep = gr.Key, Count = gr.Count() };
            foreach (var grp in result4)
            {
                Console.WriteLine("DepID = {0}, число сотрудников = {1}",
                    grp.Dep, grp.Count);
            }

            // 5. let
            Console.WriteLine("\n5. let");
            Console.Write("Введите id: ");
            int id = Int32.Parse(Console.ReadLine());

            Console.WriteLine("Список сотрудников отдела с ID={0} " +
                "в алфавитном порядке:\n", id);
            var result5 = from w in workers let tmp = id where w.dep_id == tmp
                          orderby w.name select w;
            foreach (var grp in result5)
            {
                Console.WriteLine("{0},\tвозраст: {1}", grp.name, grp.age);
            }

            Console.ReadLine();
        }
    }
}
