import random
from datetime import date, timedelta
import config

start_date = date(2017, 1, 1)
end_date = date(2019, 12, 31)
plen=int((end_date - start_date).days)
firsthhid=68
id=firsthhid+hhnr
purfile=open("pur.txt", "w")
artfeat=[]
for i in range(artfeatnr):
    if i==0:
        nrnv=pgcnt
    else:
        nrnv=random.randint(1, 10)
    s=0
    w={}
    for k in range(0, nrnv):
        w[k]=random.uniform(0, 1)
        s+=w[k]
    feat={}
    for k in range(0, nrnv):
        feat[id]=w[k]/s
        id+=1
    artfeat.append(feat)

pgfeat=[]
for ipg in range(0, pgcnt):
    pgfeat.append([1]+random.sample(range(2, artfeatnr), featperpg))

firstshopid=id
articles=[]
for i in range(0, artcnt):
    article={}
    vp=random.uniform(0, 1)
    s=0
    ipg=0
    for val in artfeat[0]:
        s+=artfeat[0][val]
        if s>=vp:
            break
        ipg+=1
    article[0]=val
    print("article %d: pg %d" % (i, val))
    for ifeat in pgfeat[ipg]:
        vp=random.uniform(0, 1)
        s=0
        for val in artfeat[ifeat]:
            s+=artfeat[ifeat][val]
            if s>=vp:
                break
        article[ifeat]=val
        print("article %d: %d %d" % (i, ifeat, val))
        #article volume
    article[-1]=round(2**random.uniform(-1,4),3)
    articles.append(article)

recid=1000
for i in range(0, hhnr):
    print("hh %d\n" % (i+firsthhid))
    nrrec=random.randint(1, maxrecperhh)
    for k in range(0, nrrec):
        print(recid, end='\t', file=purfile)
        recid+=1
        print(i+firsthhid, end='\t', file=purfile)
        date=start_date+timedelta(days=random.randint(0, plen))
        print(date, end='\t', file=purfile)
        shop=random.randint(firstshopid, firstshopid+shopcnt)
        print(shop, end='\t', file=purfile)
        nr=round(2**random.uniform(-1,5))
        print(nr, end='\t', file=purfile)
        val=nr*round(2**random.uniform(-1,5),2)
        print(val, end='\t', file=purfile)
        article=articles[random.randint(0, artcnt-1)]
        vol=nr*article[-1]
        print(vol, end='\t', file=purfile)
        for j in range(0, artfeatnr):
            if j in article:
                print("%d %d\n" % (j, article[j]))
                print(article[j], end='\t', file=purfile)
            else:
                print("NULL", end='\t', file=purfile)
        bf=2**random.uniform(-1,1)
        print(bf, end='\t', file=purfile)
        rw=2**random.uniform(-1,1)
        print(rw, file=purfile)
purfile.close()

pursql=open("pur.sql", "w")
print("drop table if exists purchases;", file=pursql)
print("create table purchases (", file=pursql)
print("\trec_id int,", file=pursql)
print("\thousehold_id int,", file=pursql)
print("\tpur_date text,", file=pursql)
print("\tshop_id int,", file=pursql)
print("\tpacks int,", file=pursql)
print("\tvalue float,", file=pursql)
print("\tvolume float,", file=pursql)
print("\tcategory_id int,", file=pursql)
print("\tbrand_id int,", file=pursql)
for i in range(2, artfeatnr):
    print("\tfeat"+str(i)+"_id int default null,", file=pursql)
print("\tbrand_factor float,", file=pursql)
print("\trw float);", file=pursql)
print(".mode tabs", file=pursql)
print(".import pur.txt purchases", file=pursql)
print(".headers on", file=pursql)
print("select * from purchases limit 10;", file=pursql)
pursql.close()

artaxfile=open("artaxis.txt", "w")
for article in articles:
	print(article[0], article[0], article[1], article[1], article[1], article[1], article[0], sep='\t', file=artaxfile)
	print(article[0], article[0], article[1], article[1], article[0], article[0], "TOTAL", sep='\t', file=artaxfile)
	print(article[0], article[0], article[1], article[1], "TOTAL", "TOTAL", "NULL", sep='\t', file=artaxfile)
artaxfile.close()

artaxsql=open("artaxis.sql", "w")
print("drop table if exists artaxis;",file=artaxsql)
print("create table artaxis (",file=artaxsql)
print("\tcat_id int,",file=artaxsql)
print("\tcat_name varchar(30),",file=artaxsql)
print("\tbrnd_id int,",file=artaxsql)
print("\tbrnd_name varchar(30),",file=artaxsql)
print("\tpostext varchar(60),",file=artaxsql)
print("\tpos_id varchar(30),",file=artaxsql)
print("\tparent_id varchar(30));",file=artaxsql)
print(".mode tabs",file=artaxsql)
print(".import artaxis.txt artaxis",file=artaxsql)
print(".headers on",file=artaxsql)
print("select * from artaxis limit 10;",file=artaxsql)
artaxsql.close()
