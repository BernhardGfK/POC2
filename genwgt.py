from datetime import date, timedelta
import random
import calendar
import config

def daterange(start_date, end_date, length=1):
    for n in range(0, int((end_date - start_date).days), length):
        yield start_date + timedelta(n)

filewgts = open("wgt.txt", "w")
firsthhid=68
id=firsthhid
start_date = date(2016, 12, 26)
end_date = date(2020, 1, 5)
for single_date in daterange(start_date, end_date, 7):
    end_date = single_date + timedelta(6)
    print(single_date.strftime("%Y-%m-%d %A"), end_date.strftime("%Y-%m-%d %A"))
    s=0
    w={}
    for j in range(0, hhnr):
        w[j]=random.uniform(0, 1)
        s+=w[j]
    for j in range(0, hhnr):
        print(firsthhid+j, single_date.strftime("%Y-%m-%d"), end_date.strftime("%Y-%m-%d"), w[j]/s*hhnr, 1, sep='\t', file=filewgts)
for byear in range(2017, 2020):
    for bmonth in range(1, 13):
        for eyear in range(byear, 2020):
            if(byear==eyear):
                semonth=bmonth
            else:
                semonth=1
            for emonth in range(semonth, 13):
                begin="{:4d}-{:02d}-{:02d}".format(byear, bmonth, 1)
                endd=calendar.monthrange(eyear, emonth)[1]
                end="{:4d}-{:02d}-{:02d}".format(eyear, emonth, endd)
                print(begin, end)
                s=0
                w={}
                for j in range(0, hhnr):
                    w[j]=random.uniform(0, 1)
                    s+=w[j]
                for j in range(0, hhnr):
                    print(firsthhid+j, begin, end, w[j]/s*hhnr, 0, sep='\t', file=filewgts)
filewgts.close()

wgtsql=open("wgt.sql", "w")
print("drop table if exists weights;", file=wgtsql)
print("create table weights (", file=wgtsql)
print("\thousehold_id int,", file=wgtsql)
print("\tfrom_date text,", file=wgtsql)
print("\tto_date text,", file=wgtsql)
print("\tweight float,", file=wgtsql)
print("\tstandard int);", file=wgtsql)
print(".mode tabs", file=wgtsql)
print(".import wgt.txt weights", file=wgtsql)
print(".headers on", file=wgtsql)
print("select * from weights limit 10;", file=wgtsql)
wgtsql.close()
