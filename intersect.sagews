def intersect(seg1,seg2):
    a=seg1[0]
    b=seg1[1]
    c=seg2[0]
    d=seg2[1]
    #if slopes are equal, they're either the same line or parallel
    m1=(b[1]-a[1])/(b[0]-a[0])
    m2=(d[1]-c[1])/(d[0]-c[0])
    if m1==m2:
        #if slope between a point on seg1 and a point on seg2 is same as m1,
        #then all four points are on same line.
        if (a[1]-d[1])/(a[0]-d[0]):
            return True
        else:
            return False
    t=var('t')
    s=var('s')
    Sol=solve([t*a[0]+(1-t)*b[0]==s*c[0]+(1-s)*d[0], t*a[1]+(1-t)*b[1]==s*c[1]+(1-s)*d[1]],s,t,solution_\
dict=True)
    print Sol
    t=Sol[0][t]
    s=Sol[0][s]
    if 0<=t<=1 and 0<=s<=1:
        return True
    else:
        return False
