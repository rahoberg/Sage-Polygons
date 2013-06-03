class polygon_set(object):

    def __init__(self,array):
        self.corners = set_corners(array)
        self.edges = set_edges(self.corners)

    def self.edges(array):
        #returns an array of arrays of edges for each sub polygon
        edges = []
        for polygon in self.corners:
            polygon_edges = []
            for i in range(len(polygon)):
                polygon_edges = polygon_edges + (polygon(i),polygon(i+1))
            edges = edges + polygon_edges
        return edges

    def graph(self):
        print self.corners[0]
        p=polygon2d(self.corners[0],fill=False,axes=False)
        for vertices in self.corners[1:]:
            p+=polygon2d(vertices,fill=False,axes=False)
        show(p)

    def set_corners(array):
        return array

    def area(self):
        area = 0
        for polygon in self.corners:
            for i in range(length(polygon)-1):
                area += polygon[i-1][0]*polygon[i][1] - polygon[i-1][1]*polygon[i][1]
        return(area/2)

    def perimeter(self):
        perm = 0
        for polygons in self.corners:
            for i in range(len(polygon)):
                perm += ((polygon[i][0]-polygon[i-1][0])^2+(polygon[i][1]-polygon[i-1][1])^2)^(1/2)

    def union(self, other):

        pass

    def set_difference(self, other):
        pass

    def intersections_with(self, seg):
        r"""
        Takes a line segment seg = (a,b) and returns the list of points on the polygon that
        intersects seg, ordered from closest to a.

        !!!!!!Currently can't deal with co-linear segments.

        EXAMPLES:

            insert examples, you lazy author.

        AUTHOR: Mary Solbrig
        """

        points = []
        for polygon in self.edges:
            for edge in polygon:
                if (intersect(seg,edge)[0]):
                    if (intersect(seg,edge)[1] == None):
                        #I don't really know what to do here yet
                        pass
                    else:
                        points += intersect(seg,edge)[1]
             #orders the points
             if (seg[0][0] < seg[1][0]):
                 #order by increasing x
                 points.sort(key=lambda tup: tup[0])
             elif (seg[0][0] < seg[1][0]):
                 #order by decreasing x
                 points.sort(key=lambda tup: -tup[0])
             elif (seg[0][1] < seg[1][1]):
                 #order by increasing y
                 points.sort(key=lambda tup: tup[1])
             elif (seg[0][1] > seg[1][1]):
                 #order by decreasing y
                 points.sort(key=lambda tup: -tup[1])
        return points

    def contains_line(self, seg):
        r"""
        Takes a line segment seg = (a,b) and returns True if and only if a in p, b in p,
        and the line segment doesn't intersect any edge of p.

        EXAMPLES:

            insert examples, you lazy author.

        AUTHOR: Mary Solbrig
        """

        if(self.contains_point(seg[0]) and self.contains_point(seg[1])):
            if(len(self.intersections_with(seg)) == 0):
                return True
        else:
            return False


    def contains_point(self, point):
        r"""

        Returns a boolean indicating wether point lies inside polygon

        EXAMPES::
            sage: p = polygon([[(-1,-1),(1,-1),(1,1),(-1,1)],[(1,1),(4,1),(3,2),(1,1)]])
            sage: polygon.contains((0,0))

            returns TRUE

            sage: p = polygon([[(-1,-1),(1,-1),(1,1),(-1,1)],[(1,1),(4,1),(3,2),(1,1)]])
            sage: polygon.contains((-1,-1))

            returns TRUE

            sage: p = polygon([[(-1,-1),(1,-1),(1,1),(-1,1)],[(1,1),(4,1),(3,2),(1,1)]])
            sage: polygon.contains((-1,0))

            returns TRUE

            sage: p = polygon([[(-1,-1),(1,-1),(1,1),(-1,1)],[(1,1),(4,1),(3,2),(1,1)]])
            sage: polygon.contains((1.5,.5))

            returns FALSE

        AUTHOR: Mary Solbrig
        """

        #Note: could be made better by using self.edges instead of self.corners
        seg = (point,(point[0],self.bounding_rectangle()[2]))
        for polygon in self.corners:
            if point in self.corners:
                return True
            count = 0
            for i in range(len(polygon)):
                seg2 = (polygon[i-1],polygon[i])
                #checks for point lying on an edge
                if((seg2[1][0]-point[0]) + (point[0]-seg2[0][0]) == (seg2[1][0]-seg2[0][0])):
                    if((seg2[1][1]-point[1]) + (point[1]-seg2[0][1]) == (seg2[1][1]-seg2[0][1])):
                        return True
                #for each intersection, adds 1 to count
                if(intersect(seg,seg2)[0]):
                    #tests for case of vertical line directly above point
                    if(intersect(seg,seg2)[1] == None):
                        if(polygon[i-2][0] <= polygon[i-1][0]):
                            coming_from_left = True
                        else:
                            coming_from_left = False
                        if(polygon[i][0] <= polygon[(i+1) % len(polygon)][0]):
                            going_to_left = True
                        else:
                            going_to_left = False
                        if(coming_from_left != going_to_left):
                            count = count + 1
                    else:
                        count = count + 1
            if(count%2 == 1):
                return True
        return False

    def bounding_rectangle(self):
        r"""

        Returns a 4-tuple indicating the minimum bounding rectangle of the polygon
        in the form (min x, max x, min y, max y)

        EXAMPES::
            EXAMPES::
            sage: p = polygon([[(-1,-1),(1,0),(.5,.5)],[(1,1),(4,1),(3,2),(1,1)]])
            sage: p.bounding_rectangle()

            returns (-1,4,-1,2)

        AUTHOR: Mary Solbrig
        """

        min_x = self.corners[0][0][0]
        max_x = self.corners[0][0][0]
        min_y = self.corners[0][0][1]
        max_y = self.corners[0][0][1]
        for polygon in self.corners:
            for coordinate in polygon:
                min_x = min(coordinate[0],min_x)
                max_x = max(coordinate[0],max_x)
                min_y = min(coordinate[1],min_y)
                max_y = max(coordinate[1],max_y)
        return((min_x,max_x,min_y,max_y))

    def contains(self, polygon):
        pass
    def contiguous(self):
        pass
    def convex(self):
        pass

    def intersect(self,seg1,seg2):
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