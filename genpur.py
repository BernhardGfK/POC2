import random
from datetime import date, timedelta

#config begin
artfeatnr=10
featperpg=5
pgcnt=10
artcnt=100
maxrecperhh=100
# config end
hhnr=10
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
    pgfeat.append(random.sample(range(0, artfeatnr), featperpg))

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
    #for ifeat in pgfeat[ipg]:
    for ifeat in pgfeat[ipg]:
        vp=random.uniform(0, 1)
        s=0
        for val in artfeat[ifeat]:
            s+=artfeat[ifeat][val]
            if s>=vp:
                break
        article[ifeat]=val
        print("article %d: %d %d" % (i, ifeat, val))
    articles.append(article)

for i in range(0, hhnr):
    print("hh %d\n" % (i+firsthhid))
    nrrec=random.randint(1, maxrecperhh)
    for k in range(0, nrrec):
        print(i+firsthhid, end='\t', file=purfile)
        date=start_date+timedelta(days=random.randint(0, plen))
        print(date, end='\t', file=purfile)
        nr=round(2**random.uniform(-1,5))
        print(nr, end='\t', file=purfile)
        val=nr*round(2**random.uniform(-1,5),2)
        print(val, end='\t', file=purfile)
        article=articles[random.randint(0, artcnt-1)]
        for j in range(0, artfeatnr):
            if j in article:
                print("%d %d\n" % (j, article[j]))
                print(article[j], end='\t', file=purfile)
            else:
                print("", end='\t', file=purfile)
        print("", file=purfile)
purfile.close()
