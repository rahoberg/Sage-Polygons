Sage-Polygons
=============

Initial coding component: To make a non-graphics oriented polygon object. One should be able to initialize it the same way one initializes the current polygon objects (with a list of coordinates, two lists, one of x values one of y values, bounding planes, etc), but it would not initially be a graphics object. Basic properties geographic properties such as area, perimeter, intersection, union should be easy to obtain.

A = polygon(points)
B = polygon(points
A.area() = #returns area
A.perimeter() = #returns perimenter
intersection(A,B) #returns a new polygon object, or list of polygon objects if intersection is disjoint
union(A,B) #returns a new polygon object
A.convex() = #returns boolean

Extensions: Write a tutorial on how to draw nice looking graphics using sage. Implement other ways of encoding a polygon. Compute area etc. when the polygon is on another surfaces besides the plane.
