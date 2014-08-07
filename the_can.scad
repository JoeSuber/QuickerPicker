// the soda-can shaped thing with attachment points

use <faninterface_ring.scad>;
use <inside_tracker.scad>;
use <MCAD/regular_shapes.scad>;
// from faninterface
blades=56.9; 		//55.8
roundwall=57.36; 	//min measure, varies wider near corners
coneheight=6;
cubeout=60; 		//59.98
cubein=57.5;  		//56.77
conebase = 62;
walls = 1;
house_corner = 9.8;

// from inside_tracker
sleeve_height=57;
sleeve_inside=31;
sleeve_wall=5;

// local global :)
mouthrad=25;
strutwidth=7;

the_can();
translate([(mouthrad+walls*2)*2,0,walls/2])
    lids();
translate([0,(-mouthrad+walls*2)*2,walls/2])
    elbow();


module the_can(mouthrad=mouthrad, 
                lip=3, 
                walls=walls, 
                neckout=10, neckup=10, 
                ht=50,
                brackets=8,
                fudge=3){
    neckin=neckout-walls;
    neckdown=neckup-walls;
    rotate_extrude(convexity=10, $fn=128){
        translate([mouthrad,0,0])
            polygon(points=[[0,0], [0,-lip/2], 
                            [lip,-lip/2],
                            [lip,0],
                            [neckout-.6,neckup-.6], 
                            [neckout-.3,neckup-.3],
                            [neckout,neckup],
                            [neckout,ht],
                            [neckin,ht],
                            [neckin-.6,neckup-.3], 
                            [neckin-.7,neckup-.6],
                            ]);
    }

    for (i=[0:360/brackets:360]){
        rotate([-45,-90,-i+180])
        translate([mouthrad-cos(i)/2, mouthrad-sin(i)/2, ht/2])
        strut(length=ht-7);
    }    

}

module lid(thick=1.2, size=mouthrad+walls){
    // the flaps sit inside the mouth
    difference(){
        cylinder(r=mouthrad+walls, h=thick, $fn=128, center=true);
        the_can();
        }
    for (i=[1,-1], j=[1.5,-1.5])
        translate([j,size/2*i,strutwidth/2-thick/2])
            rotate([90,0,90])
            strut(length=size);
}

module lids(thick=1.2, size=mouthrad+walls, totalthick=10){
    for (i=[10,-10]){
        translate([0,i,0])
            difference(){
                lid(thick=thick, size=size);
                echo("lid diameter, thick:", thick, size*2);
                translate([0,-abs(i)/i*size/2,0]) //rotate([20,0,0])
                    cube([size*2, size, totalthick*2+.1], center=true);
            }
    }
}

module strut(thick=.93, length=45, width=strutwidth, holerad=1.7){
    linear_extrude(convexity=10, height=thick){
        difference(){
            union(){
                for (i=[1,-1])
                    translate([length/2*i,0,0])
                        circle(r=width/2, $fn=32);
                square([length, width], center=true);
            }
            for (i=[1,-1]){
                translate([length*0.5*i,0,0])
                    circle(r=holerad, $fn=16);
                if (length*.25 > holerad*2){
                    translate([length*0.25*i,0,0])
                        circle(r=holerad, $fn=16);
                }
            }
            circle(r=holerad, $fn=16);
        }
    }
}

module elbow(angle=90, ratio=1.4, longarm=30, width=6){
    realarm = longarm-width;
    shortarm = realarm/ratio;
    strut(length=longarm-width, width=6, thick=1.2, holerad=1.7);
     

    translate([-realarm/2,0,0])
    translate([-(shortarm/2 - cos(angle)*shortarm/2), 
                0, 0])
    rotate([0,0,angle])
        strut(length=(longarm-width)/ratio, width=6, thick=1.2, holerad=1.7);
}


            
