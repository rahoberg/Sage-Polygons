
class polygon_set(object):

    def __init__(self,array):
        self.corners = self.set_corners(array)
        #self.edges = self.set_edges(self.corners)

    def set_edges(self,array):
        #returns an array of arrays of edges for each sub polygon
        edges = []
        for polygon in self.corners:
            polygon_edges = []
            for i in range(len(polygon)-1):
                polygon_edges = polygon_edges + (polygon(i),polygon(i+1))
            edges = edges + polygon_edges
        return edges

    def graph(self):
        print self.corners[0]
        p=polygon2d(self.corners[0],fill=False,axes=False)
        for vertices in self.corners[1:]:
            p+=polygon2d(vertices,fill=False,axes=False)
        show(p)

    def set_corners(self,array):
        vertices=[]
        length=len(array)
        k=0
        while k<length:
            if array[k]==array[(k+1)%length]:
                k+=1
            else:
                vertices.append(array[k])
                k+=1
        length=len(vertices)
        if length<3:
            return vertices
        corners=[]
        k=0
        while k < length:
            x0=vertices[(k-1)%length][0]
            x1=vertices[k][0]
            x2=vertices[(k+1)%length][0]
            y0=vertices[(k-1)%length][1]
            y1=vertices[k][1]
            y2=vertices[(k+1)%length][1]
            try:
                m1= (y1-y0)/(x1-x0)
            except ZeroDivisionError:
                m1=infinity
            try:
                m2=(y2-y1)/(x2-x1)
            except ZeroDivisionError:
                m2=infinity
            if m1==m2:
                #skip if surrounded by colinear points
                k+=1
            else:
                corners.append(vertices[k])
                k+=1
        return [corners]

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

    def intersect(self, B):
        corners_A = self.corners
        corners_B = B.corners
        edges_A = self.edges
        edges_B = B.edges

        pointsA = []
        for i in range(len(edges_A)):
            pointsA += corners_A[i] + B.intersections_with(edges_A[i])
        pointsA += corners_A[-1]
        line_segA = []
        for i in range(len(pointsA)-1):
            line_segA += [(pointsA[i],pointsA[i+1])]
        pointsB = []
        for i in range(len(edges_B)):
            pointsB += corners_B[i] + self.intersections_with(edges_B[i])
        pointsB += corners_B[-1]
        line_segB = []
        for i in range(len(pointsB)-1):
            line_segB += [(pointsB[i],pointsB[i+1])]

        A_inner_segs = []
        inner_seg = []
        previous_state = False
        for i in range(len(line_segA)):
            current_state = B.contains_line(line_segA[i])
            if not previous_state and not current_state:
                pass
            elif not previous_state and current_state:
                inner_seg += [pointsA[i],pointsA[i+1]]
            elif previous_state and current_state:
                inner_seg += [pointsA[i+1]]
            elif previous_state and not current_state:
                A_inner_segs += inner_seg
                inner_seg = []
            previous_state = current_state
        if len(inner_seg) == 0 | len(A_inner_segs) == 0:
            A_inner_segs += inner_seg
        elif A_inner_segs[0][0] == inner_seg[-1]:
            A_inner_segs[0] += inner_seg
        else:
            A_inner_segs += inner_seg

        B_inner_segs = []
        inner_seg = []
        previous_state = False
        for i in range(len(line_segB)):
            current_state = self.contains_line(line_segB[i])
            if not previous_state and not current_state:
                pass
            elif not previous_state and current_state:
                inner_seg += [pointsB[i],pointsB[i+1]]
            elif previous_state and current_state:
                inner_seg += [pointsB[i+1]]
            elif previous_state and not current_state:
                B_inner_segs += inner_seg
                inner_seg = []
            previous_state = current_state
        if len(inner_seg) == 0 | len(B_inner_segs) == 0:
            B_inner_segs += inner_seg
        elif B_inner_segs[0][0] == inner_seg[-1]:
            B_inner_segs[0] += inner_seg
        else:
            B_inner_segs += inner_seg


        new_poly = []
        for Aseg in A_inner_segs:
            while Aseg[0] != Aseg[-1]:
                for Bseg in B_inner_segs:
                    if Bseg[0] == Aseg[-1]:
                        Aseg += Bseg[1:]
                for Aseg2 in A_inner_segs:
                    if Aseg2[0] == Aseg[-1]:
                        Aseg += Aseg2[1:]
            new_poly += Aseg
        for Bseg in B_inner_segs:
            while(Bseg[0] != Bseg[-1]):
                for Aseg in A_inner_segs:
                    if(Aseg[0] == Bseg[-1]):
                        Bseg += Aseg[1:]
                for Bseg2 in B_inner_segs:
                    if(Bseg2[0] == Bseg[-1]):
                        Bseg += Bseg2[1:]
            new_poly += Bseg
        return(polygon_set(set(new_poly)))

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
            if seg[0][0] < seg[1][0]:
                #order by increasing x
                points.sort(key=lambda tup: tup[0])
            elif seg[0][0] < seg[1][0]:
                #order by decreasing x
                points.sort(key=lambda tup: -tup[0])
            elif seg[0][1] < seg[1][1]:
                #order by increasing y
                points.sort(key=lambda tup: tup[1])
            elif seg[0][1] > seg[1][1]:
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

        if self.contains_point(seg[0]) and self.contains_point(seg[1]):
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
                if (seg2[1][0]-point[0]) + (point[0]-seg2[0][0]) == (seg2[1][0]-seg2[0][0]):
                    if (seg2[1][1]-point[1]) + (point[1]-seg2[0][1]) == (seg2[1][1]-seg2[0][1]):
                        return True
                #for each intersection, adds 1 to count
                if intersect(seg,seg2)[0]:
                    #tests for case of vertical line directly above point
                    if intersect(seg,seg2)[1] == None:
                        if(polygon[i-2][0] <= polygon[i-1][0]):
                            coming_from_left = True
                        else:
                            coming_from_left = False
                        if polygon[i][0] <= polygon[(i+1) % len(polygon)][0]:
                            going_to_left = True
                        else:
                            going_to_left = False
                        if coming_from_left != going_to_left:
                            count = count + 1
                    else:
                        count = count + 1
            if count%2 == 1:
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
