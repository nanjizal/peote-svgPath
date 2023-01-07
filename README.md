# peote-svgPath
test to see if can add svg path to peote-view

# parked project as the peote-view triangle is not working correctly.

I have got it to draw a square using two triangles  a, b, c and c, d, b
```
a---b
| / |
d---c 
```
using 
```drawing.fillQuadrilateral(20, 20,200, 20,200,200,20,200, Color.RED );```

but when I skew the bottom x:
```drawing.fillQuadrilateral( 20, 20, 200, 20, 200+50, 200, 20+50, 200, Color.RED );```

I end up with the second bottom right triangles 'b' is incorrect also shifted right.
