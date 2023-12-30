import random
import config

id=config.startid
hhfile=open("hh.txt", "w")
hhfeat=[config.bdl, config.age]
for i in range(2, config.hhfeatnr):
    nrnv=random.randint(1, 10)
    #print("number of hhfeat values: ", nrnv)
    s=0
    w={}
    for k in range(0, nrnv):
        w[k]=random.uniform(0, 1)
        s+=w[k]
    feat={}
    for k in range(0, nrnv):
        feat[id]=w[k]/s
        id+=1
    hhfeat.append(feat)
    #print(feat)

firsthhid=id
for validdate in ("2017-01-01", "2018-01-01", "2019-01-01"):
    for j in range(0, config.hhnr):
        print(id, end='\t', file=hhfile)
        print("household: ", j, id)
        id+=1
        for i in range(0, config.hhfeatnr):
            if i>=config.hhfeatstdnr and random.uniform(0, 1)<0.9:
                print("NULL", file=hhfile, end='\t')
                continue
            vp=random.uniform(0, 1)
            s=0
            for val in hhfeat[i]:
                s+=hhfeat[i][val]
                if s>=vp:
                    break
            print("\ti: ", i, "val: ", val)
            print(val, file=hhfile, end='\t')
        print(validdate, file=hhfile)
hhfile.close()

hhsql=open("hh.sql", "w")
print("drop table if exists households;", file=hhsql)
print("create table households (", file=hhsql)
print("\thousehold_id int,", file=hhsql)
print("\tbdl_id int,", file=hhsql)
print("\tage_id int,", file=hhsql)
for i in range(2, config.hhfeatnr):
    if i>=config.hhfeatstdnr:
        print("\tfeat"+str(i)+"_id int default null,", file=hhsql)
    else:
        print("\tfeat"+str(i)+"_id int,", file=hhsql)
print("\tvalid_date text);", file=hhsql)
print(".mode tabs", file=hhsql)
print(".import hh.txt households", file=hhsql)
print(".headers on", file=hhsql)
print("select * from households limit 10;", file=hhsql)
hhsql.close()

hhaxfile=open("hhaxis.txt", "w")
for b in config.bdl:
    for a in config.age:
        print(b, b, a, a, a, a, b, sep='\t', file=hhaxfile)
        print(b, b, a, a, b, b, "TOTAL", sep='\t', file=hhaxfile)
        print(b, b, a, a, "TOTAL", "TOTAL", "NULL", sep='\t', file=hhaxfile)
hhaxfile.close()

hhaxsql=open("hhaxis.sql", "w")
print("drop table if exists hhaxis;",file=hhaxsql)
print("create table hhaxis (",file=hhaxsql)
print("\tbdl_id int,",file=hhaxsql)
print("\tbdl_name varchar(30),",file=hhaxsql)
print("\tage_id int,",file=hhaxsql)
print("\tage_name varchar(30),",file=hhaxsql)
print("\tpostext varchar(60),",file=hhaxsql)
print("\tpos_id varchar(30),",file=hhaxsql)
print("\tparent_id varchar(30));",file=hhaxsql)
print(".mode tabs",file=hhaxsql)
print(".import hhaxis.txt hhaxis",file=hhaxsql)
print(".headers on",file=hhaxsql)
print("select * from hhaxis limit 10;",file=hhaxsql)
hhaxsql.close()
