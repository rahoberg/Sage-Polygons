class polygon_set(object):

    def __init__(self,array):
        self.corners = set_corners(array)

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
            for i in range(length(polygon)):
                perm += ((polygon[i][0]-polygon[i-1][0])^2+(polygon[i][1]-polygon[i-1][1])^2)^(1/2)

    def union(self, other):
        pass
    def intersection(self, other):
        pass
    def set_difference(self, other):
        pass
    def contains(self, point):
        pass
    def contains(self, polygon):
        pass
    def contiguous(self):
        pass
    def convex(self):
        pass
