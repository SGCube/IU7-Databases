# METRO_DB Data Generator
import random
from faker import Faker
import datetime

random.seed()
fake = Faker('ru_RU')


##############################################################################
# Data Classes #
##############################################################################

class Time:
    hour = 0
    minute = 0
    second = 0

    def __init__(self, h=0, m=0, s=0):
        self.hour = h % 24
        self.minute = m % 60
        self.second = s % 60

    def __str__(self):
        return "%02d:%02d:%02d" % (self.hour, self.minute, self.second)

    def in_secs(self):
        return self.hour * 3600 + self.minute * 60 + self.second

    @staticmethod
    def generate(start_time=None, end_time=None, diff_time=1):
        if start_time is None:
            start_time = Time(0, 0, 0)
        if end_time is None:
            end_time = Time(23, 59, 59)

        start_secs = start_time.in_secs()
        end_secs = end_time.in_secs()

        in_secs = random.randrange(start_secs, end_secs, diff_time)

        return Time(in_secs // 3600, in_secs % 3600 // 60, in_secs % 60)


##############################################################################
# Data Class Object Generators #
##############################################################################

def phone_gen():
    phone_number = "+79"
    for k in range(9):
        phone_number += str(random.randint(0, 9))
    return phone_number


def date_gen():
    diff = random.choice([0, 20, 40, 60, 80])
    date = fake.date_between(start_date="-20y", end_date="today")
    result_date = datetime.date(date.year - diff, date.month, date.day)
    return result_date


def job_gen(sex="М"):
    jobs_male = ["машинист электропоезда",
                 "помощник машиниста",

                 "дежурный по станции",
                 "билетный кассир",
                 "инспектор службы безопасности",
                 "инспектор ЦОПМ",
                 "специалист по работе с пассажирами",

                 "уборщик станции",
                 "уборщик производственных помещений",

                 "слесарь-электрик",
                 "электромонтёр",
                 "электромеханик",
                 "дефектоскопист",
                 "плиточник",

                 "инженер-проектировщик",
                 "специалист по стоимостному инжинирингу",
                 "специалист в области проектирования",
                 "специалист по опытно-конструкторским разработкам",

                 "монтёр пути",
                 "обходчик пути и искусственных сооружений",
                 "тоннельный рабочий",

                 "фельдшер",
                 "участковый врач-терапевт"]

    jobs_female = ["дежурный по станции",
                   "билетный кассир",
                   "инспектор ЦОПМ",
                   "специалист по работе с пассажирами",

                   "уборщик станции",
                   "уборщик производственных помещений",

                   "специалист по стоимостному инжинирингу",
                   "специалист в области проектирования",
                   "специалист по опытно-конструкторским разработкам",

                   "фельдшер",
                   "участковый врач-терапевт",
                   "медицинская сестра"]

    if sex == "М":
        return random.choice(jobs_male)
    return random.choice(jobs_female)


##############################################################################
# Metro Data Classes #
##############################################################################

class Line:
    count = 0

    __code = "0"
    __name = ""
    __color = ""

    def __init__(self, code=None, name="", color=None):
        Line.count += 1

        self.__code = code
        if self.__code is None:
            self.__code = str(Line.count)

        self.__name = name

        self.__color = color
        if self.__color is None:
            self.__color = fake.safe_color_name()

    def __str__(self):
        if self.__name == "":
            return "'%s',,'%s'" % (self.__code, self.__color)
        return "'%s','%s','%s'" % (self.__code, self.__name, self.__color)

    def get_code(self):
        return self.__code

    @staticmethod
    def list_generate(size):
        gen_list = []
        for k in range(size):
            gen_list.append(Line())
        return gen_list


class Station:
    count = 0

    __id = 0
    __name = ""
    __line_code = ""
    __state = ""
    __start_time = "00:00:00"
    __end_time = "23:59:59"
    __streets = ""
    __open_date = "1930-01-01"
    __st_type = ""
    __plat_qty = 1
    __depth = 0.0

    def __init__(self, name="", line_code="", state="", start=None, end=None,
                 streets="", open_date=None, st_type="", plat_qty=0,
                 depth=None):
        Station.count += 1
        self.__id = Station.count

        self.__name = name
        if self.__name == "":
            while self.__name[-2::1] != "ая":
                self.__name = fake.street_title()

        self.__line_code = line_code
        if self.__line_code == "":
            self.__line_code = str(random.randint(1, Line.count))

        self.__state = state

        self.__start_time = start
        if self.__start_time is None:
            self.__start_time = Time.generate(Time(5, 0), Time(5, 30), 600)
        self.__end_time = end
        if self.__end_time is None:
            self.__end_time = Time.generate(Time(1, 0), Time(2, 0), 600)

        self.__streets = streets
        if self.__streets == "":
            size = random.randint(1, 5)
            for i in range(size):
                self.__streets += fake.street_name() + ","
            self.__streets = self.__streets[:-1]

        self.__open_date = open_date
        if self.__open_date is None:
            self.__open_date = date_gen()

        self.__st_type = st_type

        self.__plat_qty = plat_qty
        if self.__plat_qty == 0:
            self.__plat_qty = random.choice([1, 1, 1, 1, 1, 2])

        self.__depth = depth
        if self.__depth is None:
            self.__depth = random.random() * 100

    def __str__(self):
        return "%d,'%s','%s','%s','%s','%s','%s','%s','%s',%d,%.1f" % (
            self.__id, self.__name, self.__line_code, self.__state,
            self.__start_time, self.__end_time, self.__streets,
            self.__open_date, self.__st_type, self.__plat_qty, self.__depth)

    @staticmethod
    def list_generate(size, lines_list):
        stations_qty = size
        lines_qty = len(lines_list)

        lines_lengths = []
        lines_codes = []

        avg = stations_qty // lines_qty
        max_amount = 3 * avg // 2

        gen_list = []
        for k in range(len(lines_list)):
            lines_lengths.append(
                random.randint(1, min(max_amount, stations_qty)))
            lines_codes.append(lines_list[k].get_code())
            stations_qty -= lines_lengths[k]

            for i in range(lines_lengths[k]):
                gen_list.append(Station(fake.street_title(), lines_codes[k]))

        return gen_list, lines_lengths


class Depot:
    count = 0

    __id = 0
    __name = ""
    __nearest_station = 0
    __open_date = ""
    __address = ""

    def __init__(self, name="", station=0, open_date=None, address=None):
        Depot.count += 1
        self.__id = Depot.count

        self.__nearest_station = station

        self.__name = name
        if self.__name == "":
            while self.__name[-2::1] != "ая":
                self.__name = fake.street_title()

        self.__open_date = open_date
        if self.__open_date is None:
            self.__open_date = date_gen()

        self.__address = address
        if self.__address is None:
            self.__address = fake.street_address()

    def __str__(self):
        return "%d,'%s',%d,'%s','%s'" % (self.__id, self.__name,
                                         self.__nearest_station,
                                         self.__open_date, self.__address)

    @staticmethod
    def list_generate(lines_lengths, lines_list):
        gen_list = []
        depot_qty = []
        for k in range(len(lines_list)):
            depot_qty.append(lines_lengths[k] // 15 + 1)
            for i in range(depot_qty[k]):
                nearest_station = random.randint(1 + 15 * i, 15 * (i + 1))
                gen_list.append(Station(fake.street_title(), nearest_station))
        return gen_list


class Train:
    count = 0

    __model = ""
    __wagons_qty = 0
    __seats_qty = 0
    __construction_start = 0
    __construction_end = None
    __exploit_since = 0

    def __init__(self, model="", wagons_qty=-1, seats_qty=-1,
                 construction_start=0, construction_end=-1, exploit_since=0):
        Train.count += 1
        self.__model = model
        if self.__model == "":
            self.__model = str(Train.count)

        self.__wagons_qty = wagons_qty
        if self.__wagons_qty < 0:
            self.__wagons_qty = random.randint(5, 8)

        self.__seats_qty = seats_qty
        if self.__seats_qty < 0:
            self.__seats_qty = random.randint(40, 60)

        self.__construction_start = construction_start
        if self.__construction_start == 0:
            self.__construction_start = random.randint(1970, 2018)

        self.__construction_end = construction_end
        if self.__construction_end == -1:
            if self.__construction_start < 2016:
                self.__construction_end = random.randint(
                    self.__construction_start, 2016)
            else:
                self.__construction_end = None

        self.__exploit_since = exploit_since
        if self.__exploit_since == 0:
            self.__exploit_since = random.randint(self.__construction_start,
                                                  self.__construction_start + 2)

    def __str__(self):
        if self.__construction_end is None:
            return "'%s',%d,%d,%d,,%d" % (self.__model, self.__wagons_qty,
                                          self.__seats_qty,
                                          self.__construction_start,
                                          self.__exploit_since)
        return "'%s',%d,%d,%d,%d,%d" % (self.__model, self.__wagons_qty,
                                        self.__seats_qty,
                                        self.__construction_start,
                                        self.__construction_end,
                                        self.__exploit_since)

    @staticmethod
    def list_generate(size):
        gen_list = []
        for k in range(size):
            gen_list.append(Train())
        return gen_list


class Worker:
    count = 0

    __id = 0
    __name = ""
    __sex = "М"
    __birth_date = ""
    __phone_number = ""
    __address = ""
    __job = ""
    __exp = 0

    def __init__(self, name="", sex="", birth_date=None, phone_number=None,
                 address=None, job=None, exp=None):
        Worker.count += 1
        self.__id = Worker.count
        self.__sex = sex
        if self.__sex == "":
            self.__sex = random.choice(["М", "Ж"])

        self.__name = name
        if self.__name == "":
            if self.__sex == "М":
                self.__name = "%s %s %s" % (fake.last_name_male(),
                                            fake.first_name_male(),
                                            fake.middle_name_male())
            else:
                self.__name = "%s %s %s" % (fake.last_name_female(),
                                            fake.first_name_female(),
                                            fake.middle_name_female())

        self.__birth_date = birth_date
        if self.__birth_date is None:
            self.__birth_date = fake.date_of_birth(minimum_age=24,
                                                   maximum_age=60)
        self.__phone_number = phone_number
        if self.__phone_number is None:
            self.__phone_number = phone_gen()

        self.__address = address
        if self.__address is None:
            self.__address = fake.street_address()

        self.__job = job
        if self.__job is None:
            self.__job = job_gen(self.__sex)

        age = (datetime.date.today() - self.__birth_date).days // 365

        self.__exp = exp
        if self.__exp is None:
            if age - 24 == 0:
                self.__exp = 0
            else:
                self.__exp = random.randint(0, age - 24)

    def __str__(self):
        return "%d,'%s','%s','%s','%s','%s','%s',%d" % (self.__id, self.__name,
                                                        self.__sex,
                                                        self.__birth_date,
                                                        self.__phone_number,
                                                        self.__address,
                                                        self.__job, self.__exp)

    @staticmethod
    def list_generate(size):
        gen_list = []
        for k in range(size):
            gen_list.append(Worker())
        return gen_list


##############################################################################
# CSV Create methods #
##############################################################################

def csv_list_write(file_name, data_list):
    file = open(file_name, "w")
    for data in data_list:
        file.write(str(data) + "\n")
    file.close()


##############################################################################
# Call methods #
##############################################################################

def generate_all():
    lines_list = Line.list_generate(20)
    stations_list, lines_lengths = Station.list_generate(400, lines_list)
    depots_list = Depot.list_generate(lines_lengths, lines_list)
    trains_list = Train.list_generate(30)
    workers_list = Worker.list_generate(1000)

    csv_list_write("data_lines.csv", lines_list)
    csv_list_write("data_stations.csv", stations_list)
    csv_list_write("data_depots.csv", depots_list)
    csv_list_write("data_trains.csv", trains_list)
    csv_list_write("data_workers.csv", workers_list)


if __name__ == "__main__":
    generate_all()
