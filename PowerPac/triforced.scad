use <libtriangles.scad>;

side=120;
bisector=side*0.5*sqrt(3);
ht=3.2;
floor_ht=1.2;
xpixels=527;
ypixels=454;
htcut=255;
biggen=4;

union(){
    intersection(){
        translate([(side/2), -(bisector)*0.5, 0]) rotate([90,0,180]) 
            scale([(side+1)/side, (bisector+10)/bisector, 1])
                eqlprism(side,ht,bisector);
        scale([side/xpixels, bisector/ypixels, (htcut/ht)/htcut])
            surface(file = "triforce_try5.png", center = true, convexity = 5);
    }

    translate([(side+biggen/2)/2, -(bisector+biggen/2)*0.5, 0]) rotate([90,0,180])
        scale([(side+biggen)/side, (bisector+biggen)/bisector, 1])
            eqlprism(side,floor_ht,bisector);
}