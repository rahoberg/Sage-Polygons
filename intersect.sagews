def intersect(seg1,seg2):
    #one segment is [a,b], the other is [c,d]
    a=seg1[0]
    b=seg1[1]
    c=seg2[0]
    d=seg2[1]
    #if slopes are equal, they're either the same line or parallel
    if (b[1]-a[1])*(d[0]-c[0]) == (d[1]-c[1])*(b[0]-a[0]):
        #if slope between a point on seg1 and a point on seg2 is same as m1,
        #then all four points are on same line. Then just need to check they overlap.
        if (a[1]-d[1])*(b[0]-c[0])==(b[1]-c[1])*(a[0]-d[0]) and min(a[0],b[0])<=max(c[0],d[0]) and max(a[0],b[0])>=min(c[0],d[0]):
            return (True,(max(min(a[0],b[0]),min(c[0],d[0])),max(min(a[1],b[1]),min(c[1],d[1]))))
        else:
            return (False,None)
    t=var('t')
    s=var('s')
    Sol=solve([t*a[0]+(1-t)*b[0]==s*c[0]+(1-s)*d[0], t*a[1]+(1-t)*b[1]==s*c[1]+(1-s)*d[1]],s,t,solution_dict=True)
    t=Sol[0][t]
    s=Sol[0][s]
    if 0<=t<=1 and 0<=s<=1:
        return (True,(t*a[0]+(1-t)*b[0],t*a[1]+(1-t)*b[1]))
    else:
        return False
#intersect(((0,0),(1,1)),((1,0),(0,1)))
#intersect(((0,0),(0,1)),((1,0),(1,1)))
#intersect(((0,0),(2/3,2/3)),((1/2,1/2),(1,1)))
