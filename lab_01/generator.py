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
    color_list = ["красный", "зелёный", "синий", "голубой", "коричневый",
                  "оранжевый", "фиолетовый", "жёлтый", "серый", "салатовый",
                  "бирюзовый", "чёрный", "розовый", "белый", "сиреневый",
                  "розовый", "персиковый", "бордовый", "золотой", "фуксия"]

    param_names = "[Code],[Name],[Color]"
    format_str = "'%s','%s','%s'"
    null_str = "'%s',null,'%s'"

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
        if self.__color is None and len(Line.color_list) > 0:
            self.__color = random.choice(Line.color_list)
            Line.color_list.remove(self.__color)

    def __str__(self):
        if self.__name == "":
            return Line.null_str % (self.__code, self.__color)
        return Line.format_str % (self.__code, self.__name, self.__color)

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
    param_names = "[ID],[Name],[Line_ID],[Station_State],[Open_Time],"\
                  "[Close_Time],[Streets],[Open_Date],"\
                  "[Platforms_Qty],[Depth]"
    format_str = "%d,'%s','%s','%s','%s','%s','%s','%s',%d,%.2f"

    __id = 0
    __name = ""
    __line_code = ""
    __state = ""
    __start_time = "00:00:00"
    __end_time = "23:59:59"
    __streets = ""
    __open_date = "1930-01-01"
    __plat_qty = 1
    __depth = 0.0

    def __init__(self, name="", line_code="", state="Работает",
                 start=None, end=None, streets="", open_date=None,
                 plat_qty=0, depth=None):
        Station.count += 1
        self.__id = Station.count

        self.__name = name
        if self.__name == "":
            while self.__name[-2:] != "ая":
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
                self.__streets += fake.street_name() + ", "
            self.__streets = self.__streets[:-2]

        self.__open_date = open_date
        if self.__open_date is None:
            self.__open_date = date_gen()

        self.__plat_qty = plat_qty
        if self.__plat_qty == 0:
            self.__plat_qty = random.choice([1, 1, 1, 1, 1, 2])

        self.__depth = depth
        if self.__depth is None:
            self.__depth = random.random() * 100

    def __str__(self):
        return Station.format_str % (
            self.__id, self.__name, self.__line_code, self.__state,
            self.__start_time, self.__end_time, self.__streets,
            self.__open_date, self.__plat_qty, self.__depth)

    @staticmethod
    def list_generate(size, lines_list):
        stations_qty = size
        lines_qty = len(lines_list)

        lines_lengths = []
        lines_codes = []

        avg = stations_qty // lines_qty
        max_amount = 3 * avg // 2

        gen_list = []
        for k in range(len(lines_list) - 1):
            lines_lengths.append(
                random.randint(5, min(max_amount, stations_qty)))
            lines_codes.append(lines_list[k].get_code())
            stations_qty -= lines_lengths[k]

            for i in range(lines_lengths[k]):
                gen_list.append(Station("", lines_codes[k]))

        k = len(lines_list) - 1

        lines_lengths.append(stations_qty)
        lines_codes.append(lines_list[k].get_code())
        stations_qty -= lines_lengths[k]

        for i in range(lines_lengths[k]):
            gen_list.append(Station(fake.street_title(), lines_codes[k]))

        lines_ranges = []
        k = 0
        for i in range(len(lines_list)):
            lines_ranges.append((k + 1, k + lines_lengths[i]))
            k += lines_lengths[i]

        return gen_list, lines_lengths, lines_ranges


class Depot:
    count = 0
    param_names = "[ID],[Name],[Nearest_Station_ID],[Open_Date]"
    format_str = "%d,'%s',%d,'%s'"

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
        return Depot.format_str % (self.__id, self.__name,
                                   self.__nearest_station, self.__open_date)

    def get_id(self):
        return self.__id

    @staticmethod
    def list_generate(lines_lengths):
        gen_list = []
        depot_qty = []
        for k in range(len(lines_lengths)):
            depot_qty.append(lines_lengths[k] // 15 + 1)
            for i in range(depot_qty[k]):
                nearest_station = random.randint(1 + 15 * i, 15 * (i + 1))
                gen_list.append(Depot(fake.street_title(), nearest_station))
        return gen_list


class Train:
    count = 0
    param_names = "[Model],[Wagons_Qty],[Seats_Qty],[Produce_Start_y],"\
                  "[Produce_End_y],[Exploit_Since_y]"
    format_str = "'%s',%d,%d,%d,%d,%d"
    null_str = "'%s',%d,%d,%d,null,%d"

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
            return Train.null_str % (self.__model, self.__wagons_qty,
                                     self.__seats_qty,
                                     self.__construction_start,
                                     self.__exploit_since)
        return Train.format_str % (self.__model, self.__wagons_qty,
                                   self.__seats_qty,
                                   self.__construction_start,
                                   self.__construction_end,
                                   self.__exploit_since)

    def get_model(self):
        return self.__model

    @staticmethod
    def list_generate(size):
        gen_list = []
        for k in range(size):
            gen_list.append(Train())
        return gen_list


class Worker:
    count = 0
    param_names = "[ID],[Name],[Sex],[Birth_Date],[Phone_Number],[Address],"\
                  "[Job],[Station_ID],[Line_Code],[Start_Time],[End_Time]"
    format_str = "%d,'%s','%s','%s','%s','%s','%s',%d,'%s','%s','%s'"
    null1_str = "%d,'%s','%s','%s','%s','%s','%s',null,'%s','%s','%s'"
    null2_str = "%d,'%s','%s','%s','%s','%s','%s',%d,null,'%s','%s'"
    null3_str = "%d,'%s','%s','%s','%s','%s','%s',null,null,'%s','%s'"

    __id = 0
    __name = ""
    __sex = "М"
    __birth_date = ""
    __phone_number = ""
    __address = ""
    __job = ""

    __station = None
    __line = None
    __start_time = ""
    __end_time = ""

    def __init__(self, station, line, name="", sex="", birth_date=None, phone_number=None,
                 address=None, job=None):
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

        self.__start_time = Time.generate(Time(5, 0), Time(14, 0))
        self.__end_time = Time.generate(self.__start_time, Time(14, 0))

        if self.__job in ["машинист электропоезда", "помощник машиниста"]:
            self.__station = None
            self.__line = line
        else:
            self.__station = station
            self.__line = None

    def __str__(self):
        if self.__station is None and self.__line is None:
            return Worker.null3_str % (self.__id, self.__name, self.__sex,
                                       self.__birth_date, self.__phone_number,
                                       self.__address, self.__job,
                                       self.__start_time, self.__end_time)
        if self.__station is None:
            return Worker.null1_str % (self.__id, self.__name, self.__sex,
                                       self.__birth_date, self.__phone_number,
                                       self.__address, self.__job,
                                       self.__line,
                                       self.__start_time, self.__end_time)
        if self.__line is None:
            return Worker.null2_str % (self.__id, self.__name, self.__sex,
                                       self.__birth_date, self.__phone_number,
                                       self.__address, self.__job,
                                       self.__station,
                                       self.__start_time, self.__end_time)
        return Worker.format_str % (self.__id, self.__name, self.__sex,
                                    self.__birth_date, self.__phone_number,
                                    self.__address, self.__job,
                                    self.__station, self.__line,
                                    self.__start_time, self.__end_time)

    def get_job(self):
        return self.__job

    @staticmethod
    def list_generate(size, stations, lines):
        gen_list = []
        for k in range(size):
            gen_list.append(Worker(random.randint(1, len(stations)),
                                   random.choice(lines).get_code()))
        return gen_list


##############################################################################

class Transfer:
    param_names = "[ID_Station_1],[ID_Station_2],[Time],[Length]"
    format_str = "%d,%d,%d,%d"

    __station_1 = 0
    __station_2 = 0
    __time = 0
    __length = 0

    def __init__(self, st1, st2, time, length):
        self.__station_1 = st1
        self.__station_2 = st2
        self.__time = time
        self.__length = length

    def __str__(self):
        return Transfer.format_str % (self.__station_1, self.__station_2,
                                      self.__time, self.__length)

    @staticmethod
    def list_generate(lines_ranges):
        gen_list = []
        lines_qty = len(lines_ranges)
        for i in range(lines_qty - 1):
            transfers_qty = random.randint(1, 5)
            station_1 = lines_ranges[i][0]
            line_2 = i + 1
            for j in range(transfers_qty):
                station_1 = random.randint(station_1, lines_ranges[i][1])
                line_2 = random.randint(line_2, lines_qty - 1)
                station_2 = random.randint(lines_ranges[line_2][0],
                                           lines_ranges[line_2][1])
                time = random.randint(1, 8)
                length = 250 * time + 200
                gen_list.append(Transfer(station_1, station_2,
                                         time, length))
        for i in range(lines_qty):
            for j in range(lines_ranges[i][0] + 1, lines_ranges[i][1] + 1):
                time = random.randint(3, 15)
                length = 500 * (time + 1)
                gen_list.append(Transfer(j - 1, j, time, length))
        return gen_list


class Stock:
    param_names = "[Depot_ID],[Model_Code],[Qty]"
    format_str = "%d,'%s',%d"

    __depot = 0
    __model = ""
    __qty = 0

    def __init__(self, depot, model, qty):
        self.__depot = depot
        self.__model = model
        self.__qty = qty

    def __str__(self):
        return Stock.format_str % (self.__depot, self.__model, self.__qty)

    @staticmethod
    def list_generate(trains, depots):
        gen_list = []
        for i in range(len(depots)):
            for j in range(len(trains)):
                if random.randint(0, 1):
                    gen_list.append(Stock(depots[i].get_id(),
                                          trains[j].get_model(),
                                          random.randint(5, 25)))
        return gen_list


##############################################################################
# SQL Create methods #
##############################################################################

def sql_write(file, table_name, obj_class, data_list):
    file.write("INSERT INTO %s(%s)\n\tVALUES\t" % (table_name,
                                                   obj_class.param_names))
    for i in range(len(data_list) - 1):
        file.write("(%s),\n\t\t" % str(data_list[i]))
    file.write("(%s)\n\t\t" % str(data_list[len(data_list) - 1]))
    file.write("\nGO\n\n")


##############################################################################
# Call methods #
##############################################################################

def generate_all():
    lines_list = Line.list_generate(20)
    stations_list, lines_lengths, lines_ranges =\
        Station.list_generate(400, lines_list)
    depots_list = Depot.list_generate(lines_lengths)
    trains_list = Train.list_generate(30)
    workers_list = Worker.list_generate(1000, stations_list, lines_list)
    transfers_list = Transfer.list_generate(lines_ranges)
    stocks_list = Stock.list_generate(trains_list, depots_list)

    file = open("metrodb_fill.sql", "w")
    file.write("USE MetroDB\nGO\n\n")

    sql_write(file, 'Lines', Line, lines_list)
    sql_write(file, 'Stations', Station, stations_list)
    sql_write(file, 'Depots', Depot, depots_list)
    sql_write(file, 'Trains', Train, trains_list)
    sql_write(file, 'Workers', Worker, workers_list)
    sql_write(file, 'Transfers', Transfer, transfers_list)
    sql_write(file, 'Stocks', Stock, stocks_list)

    file.close()


if __name__ == "__main__":
    generate_all()
