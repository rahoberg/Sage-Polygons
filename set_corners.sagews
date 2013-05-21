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
        if (a[1]-d[1])*(b[0]-d[0])==(b[1]-d[1])*(a[0]-d[0]) and min(a[0],b[0])<=max(c[0],d[0]) and max(a[0],b[0])>=min(c[0],d[0]):
            return (True,None)
            #e=max(min(a[0],b[0]),min(c[0],d[0]))
            #f=min(max(a[0],b[0]),max(c[0],d[0]))
            #g=max(min(a[1],b[1]),min(c[1],d[1]))
            #h=min(max(a[1],b[1]),max(c[1],d[1]))
            #return (True,[(e,g),(f,h)])
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
        return (False,None)


def Colinear(segments):
    polygon=[]
    length=len(segments)
    k=0
    while k < length:
        #assumes that end of a segment is beginning of next
        try:
            m1= (segments[k][1][1]-segments[k][0][1])/(segments[k][1][0]-segments[k][0][0])
        except ZeroDivisionError:
            m1=infinity
        try:
            m2=(segments[(k+1)%length][1][1]-segments[(k+1)%length][0][1])/(segments[(k+1)%length][1][0]-segments[(k+1)%length][0][0])
        except ZeroDivisionError:
            m2=infinity
        if m1==m2:
            polygon.append(segments[k][0])
            polygon.append(segments[k+1][1])
            k+=4
        else:
            polygon.append(segments[k][0])
            polygon.append(segments[k][1])
            k+=2
    return polygon


def set_corners(array):
    segments=[]
    polygons=[]
    length=len(array)
    if length<2:
        return array
    #check for any self-intersections- if they are found split
    for i in range(length):
        segment=[array[i],array[(i+1)%length]]
        seglen=len(segments)
        stilladd=True
        for k in range(seglen-1):
            intersection = intersect(segments[k],segment)
            if intersection[0] and (i!=length-1 or k!=0): #allow first and last to intersect
                stilladd=False
                #everything before segment k
                prevsegs=segments[:k]
                #newsegs includes segment k
                newsegs=segments[k:]
                poi=intersection[1]
                if poi!=segments[k][1]:
                    prevsegs.append([segments[k][0],poi])
                else:
                    prevsegs.append(segments[k])
                if poi!=segment[1]:
                    newsegs.append([segment[0],poi])
                    prevsegs.append([poi,segment[1]])
                else:
                    newsegs.append(segment)
                if poi!=segments[k][1]:
                   newsegs[0][0]=poi
                polygons.append(Colinear(newsegs))
                segments=prevsegs
                break
        if stilladd:
           segments.append(segment)
    polygons.append(Colinear(segments))
    return polygons
