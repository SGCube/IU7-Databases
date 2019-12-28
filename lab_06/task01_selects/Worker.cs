using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace task01_selects
{
    class Worker
    {
        public int id;
        public String name;
        public int age;
        public int exp;
        public int dep_id;

        public Worker(int _id, string _name, int _age, int _exp, int _dep_id)
        {
            id = _id;
            name = _name;
            age = _age;
            exp = _exp;
            if (exp > age)
                exp = 0;
            dep_id = _dep_id;
        }
    }

    class Department
    {
        public int id;
        public String name;

        public Department(int _id, string _name)
        {
            id = _id;
            name = _name;
        }
    }
}
