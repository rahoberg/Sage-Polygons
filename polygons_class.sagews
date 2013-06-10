%auto
class polygon_set(object):

    def __init__(self,array,holes=[]):
        self.holes=self.set_corners(holes)
        self.corners = self.set_corners(array)
        self.set_edges(self.corners)

    def __repr__(self):
        str=repr(len(self.corners))
        str+=" Polygons. Type <polygon>.corners to see corners."
        return str
        
    def set_edges(self,array):
        r"""
        Returns an array of arrays of edges for each sub polygon.
        
        EXAMPLES::
            
            sage: p = polygon_set([(0,0),(1,0),(1,1),(0,1)])
            sage: p.edges
            [[Segment: [(0, 1), (0, 0)], Segment: [(0, 0), (1, 0)], Segment: [(1, 0), (1, 1)], Segment: [(1, 1), (0, 1)]]]
            sage: p = polygon_set([(0,0),(1,0),(0,1),(.5,.5),(2,1)])
            sage: p.edges
            [[Segment: [(0.666666666666667, 0.333333333333333), (0.666666666666667, 0.333333333333333)], Segment: [(0.666666666666667, 0.333333333333333), (0.500000000000000, 0.500000000000000)], Segment: [(0.500000000000000, 0.500000000000000), (2, 1)], Segment: [(2, 1), (0.666666666666667, 0.333333333333333)]], [Segment: [(0, 0), (0, 0)], Segment: [(0, 0), (1, 0)], Segment: [(1, 0), (0.666666666666667, 0.333333333333333)], Segment: [(0.666666666666667, 0.333333333333333), (0, 0)]]]

        AUTHOR: 
            Mary Solbrig       
        """
        #
        edges = []
        for polygon in self.corners:
            polygon_edges = []
            for i in range(len(polygon)):
                polygon_edges = polygon_edges + [segment(polygon[i-1],polygon[i])]
            edges = edges + [polygon_edges]
        self.edges = edges

    def graph(self,figsize=4,fill=False,axes=False,rgbcolor=(0,0,1),thickness=None,aspect_ration=1.0,legend_label=None,**options):
        corners=self.corners
        if corners==[]:
            return
        p=polygon2d(corners[0],fill=fill,axes=axes,figsize=figsize)
        for vertices in corners[1:]:
            p+=polygon2d(vertices,fill=fill,axes=axes,figsize=figsize)
        show(p)

    def Colinear(self,segments):
        polygon=[]
        length=len(segments)
        k=0
        while k < length:
            #assumes that end of a segment is beginning of next
            try:
                m1= (segments[k].point2[1]-segments[k].point1[1])/(segments[k].point2[0]-segments[k].point1[0])
            except ZeroDivisionError:
                m1=infinity
            try:
                m2=(segments[(k+1)%length].point2[1]-segments[(k+1)%length].point1[1])/(segments[(k+1)%length].point2[0]-segments[(k+1)%length].point1[0])
            except ZeroDivisionError:
                m2=infinity
            if m1==m2:
                polygon.append(segments[k].point1)
                polygon.append(segments[k+1].point2)
                k+=3
            else:
                polygon.append(segments[k].point1)
                polygon.append(segments[k].point2)
                k+=2
        if (polygon[-1] == polygon[0]):
            return polygon[:-1]
        else:
            return polygon
      

    #initializes the array

    def set_corners(self,points):
        r"""
         r"""
        Takes a list of vertices (or a list of lists) and 
        returns a list of polygons (represented as lists of vertices) 
        without colinear points.
        If the segments of the polygons intersect, more than one polygon may be created from a single list.
        To be improved:
        Colinear line segments that intersect in segments will fail.  For example, 
            [(0,0),(1,0),(0,1),(0,0),(-1,0),(0,1)] will fail.
        Also, internal line segments will fail. For example, a star will fail.
        Now for some examples that work...

        EXAMPLES::
            sage: p=polygon_set([])
            sage: p.set_corners([[(0,0),(1,0),(0,1),(.5,.5),(2,1)]])
            [[(0.666666666666667, 0.333333333333333), (0.500000000000000,0.500000000000000), (2, 1)], [(0, 0), (1, 0),(0.666666666666667,0.333333333333333)]]
            sage: p.set_corners([(0,0),(1,1),(0,1),(1,0)])
            [[(1/2, 1/2), (1, 1), (0, 1)], [(0, 0), (1/2, 1/2), (1, 0)]]
            
            sage: p = polygon_set([(0,0),(1,0),(1,1),(0,1)])
            sage: p.corners
                [[(0, 0), (1, 0), (1, 1), (0, 1)]]
            
            sage: p = polygon_set([(0,0),(1,0),(0,1),(.5,.5),(2,1)])
            sage: p.corners
            [[(0.666666666666667, 0.333333333333333), (0.500000000000000, 0.500000000000000), (2, 1), (0.666666666666667, 0.333333333333333)], [(0, 0), (1, 0), (0.666666666666667, 0.333333333333333), (0, 0)]]

        AUTHOR:
            Rebecca Hoberg
        """
        
        if points==[]:
            return [[]]
        try: 
            iter(points[0][0])
            vertices=points
        except TypeError:
            vertices=[points]
        polygons=[]
        for array in vertices:
            array=self.pre_set_corners(array)
            segments=[]
            length=len(array)
            if length<2:
                return array
            #check for any self-intersections- if they are found split
            for i in range(length):
                seg=segment(array[i],array[(i+1)%length])
                seglen=len(segments)
                stilladd=True
                for k in range(seglen-1):
                    intersection = segments[k].intersect(seg)
                    if intersection[0] and (i!=length-1 or k!=0): #allow first and last to intersect
                        stilladd=False
                        #everything before segment k
                        prevsegs=segments[:k]
                        #newsegs includes segment k
                        newsegs=segments[k:]
                        poi=intersection[1]
                        if poi!=segments[k].point2:
                            prevsegs.append(segment(segments[k].point1,poi))
                        else:
                            prevsegs.append(segments[k])
                        if poi!=seg.point2:
                            newsegs.append(segment(seg.point1,poi))
                            prevsegs.append(segment(poi,seg.point2))
                        else:
                            newsegs.append(seg)
                        if poi!=segments[k].point2:
                            newsegs[0].point1=poi
                        polygons.append(self.Colinear(newsegs))
                        segments=prevsegs
                        break
                if stilladd:
                    segments.append(seg)
            polygons.append(self.Colinear(segments))
        return polygons
    

    
    def pre_set_corners(self,array):
        r"""
        Takes a list of vertices (or list of lists) and returns a list of polygons without duplicate points

        EXAMPLES::
            
        sage: p=polygon_set([])
        sage: p.pre_set_corners([(0,0),(1,0),(0,1)])
        [(0,0),(1,0),(0,1)]
        
        AUTHOR: Rebecca Hoberg
        """
        
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
        return corners


    def area(self):
        r"""
        EXAMPLES::
            
            sage: p = polygon_set([(0,0),(1,0),(1,1),(0,1)])
            sage: p.area()
            1
            
            sage: p = polygon_set([(0,0),(1,0),(0,1),(.5,.5),(2,1)])
            sage: p.area()
            0.250000000000000
            

        AUTHOR: 
            Mary Solbrig       
        """
        area = 0
        for polygon in self.corners:
            for i in range(len(polygon)-1):
                area += polygon[i-1][0]*polygon[i][1] - polygon[i-1][1]*polygon[i][1]
        return(area/2)

    def perimeter(self):
        r"""
        EXAMPLES::
            
            sage: p = polygon_set([(0,0),(1,0),(1,1),(0,1)])
            sage: p.area()
            4
            
            sage: p = polygon_set([(0,0),(1,0),(0,1),(.5,.5),(2,1)])
            sage: p.area
            5.52431358877053
            

        AUTHOR: 
            Mary Solbrig       
        """
        perm = 0
        for polygon in self.edges:
            for edge in polygon:
                perm += edge.length()
        return perm

    #def union(self, other):
    #Will be very similar to intersection when it works
    
    def equal(self, p1, p2):
        r"""
        approximates equality in floating points
        
        EXAMPLES::
            sage: p = polygon_set([(0,0),(1,0),(1,1),(0,1)])
            sage: p.equal((0,0),(0.00000005,0.00000005))
            True
            
            sage: p = polygon_set([(0,0),(1,0),(1,1),(0,1)])
            sage: p.equal((0,0),(0.0000001,0.00000005))
            False
            
            sage: p = polygon_set([(0,0),(1,0),(1,1),(0,1)])
            sage: p.equal((0,0),(0.0000001,0.0000001))
            False
            
            sage: p = polygon_set([(0,0),(1,0),(1,1),(0,1)])
            sage: p.equal((0,0),(0.00000005,0.0000001))
            False
        
        AUTHOR:
            Mary Solbrig
        """
        
        epsilon = 0.0000001
        return (abs(p1[0] - p2[0]) < epsilon) and (abs(p1[1] - p2[1]) < epsilon)

    def intersection(self, B):
        r"""
        EXAMPLES:
            p = polygon_set([[(-1,-1),(1,-1),(1,-.33),(.33,-.33),(.33,.33),(1,1),(-1,1)]])
            q = polygon_set([[(.2,-2),(.2,2),(2,2),(2,-2)]])
            k = p.intersection(q)
            p.graph(axes = True)
            q.graph(axes = True)
            k.graph(axes = True)
            
            p = polygon_set([[(-1,-1),(1,-1),(1,-.33),(.33,-.33),(.33,.33),(1,1),(-1,1)]])
            q = polygon_set([[(.5,-2),(.5,2),(2,2),(2,-2)]])
            k = p.intersection(q)
            p.graph(axes = True)
            q.graph(axes = True)
            k.graph(axes = True)
        """
        
        edges_A = self.edges
        edges_B = B.edges
        new_edges = []
        line_segs_A = []
        line_segs_B = []
        
        #adds line segments of A that lie in B
        for polygon in edges_A:
            points_on_edge = []
            for edge in polygon:
                points_on_edge = [edge.point1] + B.intersections_with(edge) + [edge.point2]
                for i in range(len(points_on_edge)-1):
                    if points_on_edge[i] != points_on_edge[i+1] and B.contains_line(segment(points_on_edge[i],points_on_edge[i+1])):
                        new_edges.append(segment(points_on_edge[i],points_on_edge[i+1]))


        #adds line segments of A that lie in B
        for polygon in edges_B:
            points_on_edge = []
            for edge in polygon:
                points_on_edge = [edge.point1] + self.intersections_with(edge) + [edge.point2]
                for i in range(len(points_on_edge)-1):
                    if points_on_edge[i] != points_on_edge[i+1] and self.contains_line(segment(points_on_edge[i],points_on_edge[i+1])):
                        new_edges.append(segment(points_on_edge[i],points_on_edge[i+1]))
        
        new_corners = [[]]
        i = 0
        
        
        
        #new point "equals" first point, close off polygon and begin again
        while(new_edges != []):
            new_corners[i].append(new_edges[0].point1)
            new_corners[i].append(new_edges[0].point2)
            new_edges.pop(0)
            loops = 0
            while(not(self.equal(new_corners[i][0],new_corners[i][-1])) and new_edges != [] and loops < 10000):
                loops +=1
                seen = false
                for edge in new_edges:
                    a = edge.point1
                    b = edge.point2
                    if self.equal(a,new_corners[i][-1]):
                        if not seen:
                            new_corners[i].append(b)
                            new_edges.remove(edge)
                        seen = True
                    elif self.equal(b,new_corners[i][-1]):
                        if not seen:
                            new_corners[i].append(a)
                            new_edges.remove(edge)
                        seen = True
                        

                for edge in new_edges:
                    if self.equal(edge.point1,new_corners[i][-2]) or self.equal(edge.point2,new_corners[i][-2]):
                        new_edges.remove(edge)
            i += 1
            new_corners += [[]]
        new_corners.pop(-1)     
        return(polygon_set(new_corners))

    #def set_difference(self, other):
    #    once union works, could be made from a combination of union and intersection.

    def intersections_with(self, seg):
        r"""
        Takes a line segment seg = (a,b) and returns the list of points on the boundary of the polygon that
        intersects seg, ordered from closest to a.

        !!!!!!Currently can't deal with co-linear segments.

        EXAMPLES:
            
            sage: p = polygon_set([(0,0),(0,1),(1,1),(1,0)])
            sage: seg = segment((0,0),(1,1))
            sage: p.intersections_with(seg)
            [(0, 0), (1, 1)]
            
            sage: p = polygon_set([(0,0),(0,1),(1,1),(1,0)])
            sage: seg = segment((.5,.5),(1,1))
            sage: p.intersections_with(seg)
            [(1, 1)]
            
            sage: p = polygon_set([(0,0),(0,1),(1,1),(1,0)])
            sage: seg = segment((.5,.5),(.8,.8))
            sage: p.intersections_with(seg)
            []
            
            sage: p = polygon_set([[(-1,-1),(1,-1),(1,-.33),(.33,-.33),(.33,.33),(1,1),(-1,1)]])
            sage: seg = segment((.5,-2),(.5,2))
            sage: p.intersections_with(seg)
            [(0.500000000000000, -1), (0.500000000000000, -33/100), (0.500000000000000, 1/2), (0.500000000000000, 1)]

        AUTHOR: Mary Solbrig
        """

        points = []
        for polygon in self.edges:
            for edge in polygon:
                if (seg.intersect(edge)[0]):
                    if (seg.intersect(edge)[1] == None):
                        #I don't really know what to do here yet
                        pass
                    else:
                        points += [seg.intersect(edge)[1]]
            #remove repeats
            points = list(set(points))
            #orders the points
            if seg.point1[0] < seg.point2[0]:
                #order by increasing x
                points.sort(key=lambda tup: tup[0])
            elif seg.point1[0] < seg.point2[0]:
                #order by decreasing x
                points.sort(key=lambda tup: -tup[0])
            elif seg.point1[1] < seg.point2[1]:
                #order by increasing y
                points.sort(key=lambda tup: tup[1])
            elif seg.point1[1] > seg.point2[1]:
                #order by decreasing y
                points.sort(key=lambda tup: -tup[1])
        return points

    def contains_line(self, seg):
        r"""
        Takes a line segment seg = (a,b) and returns True if and only if a in p, b in p,
        and the line segment doesn't intersect any edge of p.

        EXAMPLES:

            sage: p = polygon_set([(0,0),(0,1),(1,1),(1,0)])
            sage: seg = segment((0,0),(1,1))
            sage: print p.contains_line(seg)
            True
            
            sage: p = polygon_set([(0,0),(0,1),(1,1),(1,0)])
            sage: seg = segment((.5,.5),(1,1))
            sage: print p.contains_line(seg)
            True

            sage: p = polygon_set([(0,0),(0,1),(1,1),(1,0)])
            sage: seg = segment((.5,.5),(.8,.8))
            sage: print p.contains_line(seg)
            True
            
            sage: p = polygon_set([[(-1,-1),(1,-1),(1,-.33),(.33,-.33),(.33,.33),(1,1),(-1,1)]])
            sage: seg = segment((.5,-2),(.5,2))
            sage: print p.contains_line(seg)

            sage: p = polygon_set([[(-1,-1),(1,-1),(1,-.33),(.33,-.33),(.33,.33),(1,1),(-1,1)]])
            sage: seg = segment((.5,-.5),(.5,.5))
            sage: print p.contains_line(seg)

        AUTHOR: Mary Solbrig
        """

        if self.contains_point(seg.point1) and self.contains_point(seg.point2):
            intersections = self.intersections_with(seg)
            if len(intersections) < 2:
                return True
            elif len(intersections) == 2 and (seg.point1 in intersections) and (seg.point1 in intersections):
                return True
            else:
                return False
        else:
            return False


    def contains_point(self, point):
        r"""

        Returns a boolean indicating wether point lies inside polygon

        EXAMPLES::
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
            
            sage: p = polygon([[(-1,-1),(1,-1),(1,1),(-1,1)],[(1,1),(4,1),(3,2),(1,1)]])
            sage: polygon.contains((100,100))

            returns FALSE

            sage: p = polygon([[(-1,-1),(1,-1),(1,1),(-1,1)],[(1,1),(4,1),(3,2),(1,1)]])
            sage: polygon.contains((100,100))

            returns FALSE

        AUTHOR: Mary Solbrig
        """

        vertical_line = segment(point,(point[0],max(self.bounding_rectangle()[1]+1,point[1])))
        count = 0
        for polygon in self.edges:
            for i in range(len(polygon)):
                seg = polygon[i]
                #checks for point lying on an edge or corner
                if seg.contains(point): 
                    return True
                #for each intersection, adds 1 to count
                intersect = vertical_line.intersect(seg)
                if intersect[0]:
                    #tests for case of vertical line directly above point
                    if intersect[1] == None:
                        if(polygon[i-1].point1[0] <= seg.point1[0]):
                            coming_from_left = True
                        else:
                            coming_from_left = False

                        if polygon[(i+1) % len(polygon)].point2[0] <= seg.point2[0]:
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

        EXAMPLES::
   
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
        
class segment(object):
    def __init__(self,point1,point2):
        #self.seg=[point1,point2]
        self.point1=point1
        self.point2=point2
        
    def __repr__(self):
        return "Segment: " + str([self.point1,self.point2])
        
    def intersect(self,other):
        #one segment is [a,b], the other is [c,d]
        a=self.point1
        b=self.point2
        c=other.point1
        d=other.point2
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
    
    def length(self):
        return ((self.point1[0] - self.point2[0])^2 + (self.point1[1] - self.point2[1])^2)^(1/2)
            
    def contains(self,point):
        if point == self.point1 or point == self.point2:
            return True
        elif self.point1 == self.point2:
            return False
        else:
            dot = (self.point2[0]-self.point1[0])*(point[0]-self.point1[0]) + (self.point2[1]-self.point1[1])*(point[1]-self.point1[1])
            abs1 = ((self.point2[0]-point[0])^2 + (self.point2[1]-point[1])^2)^(1/2)
            abs2 = ((point[0]-self.point1[0])^2 + (point[1]-self.point1[1])^2)^(1/2)
            abs3 = ((self.point2[0]- self.point1[0])^2 + (self.point2[1]-self.point1[1])^2)^(1/2)
            if abs((abs1 + abs2) - abs3) < .00001:
                return True
            else:
                return False
