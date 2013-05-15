class polygon_set(object):

    def __init__(self,array):
        corners = set_corners(array)

    def set_corners(array):
        return array

    def area(self):
        area = 0
        for polygons in self.corners:
            for i in range(length(polygon)):
                area += polygon[i-1][0]*polygon[i][1] - polygon[i-1][1]*polygon[i][1]
        return(area/2)

    def perimeter(self):
        perm = 0
        for polygons in self.corners:
            for i in range(length(polygon)):
                perm += ((polygon[i][0]-polygon[i-1][0])^2+(polygon[i][1]-polygon[i-1][1])^2)^(1/2)

    def union(self, other):

    def intersection(self, other):

    def set_difference(self, other):

    def contains(self, point):

    def contains(self, polygon):

    def contiguous(self):

    def convex(self):

