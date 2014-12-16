// stackable trays bolt together
// topper narrows to exact card size for camera positioning
// IR sensor positions allow mcu to adjust card height
// screw drive allows stepper disable to reduce power/heat
// 100lb test thread x 4 for lifting

/*
#figure shaft-center distances for gearing:
# copy echo locations
import numpy as np

 def dist (a,b):
    x = (a[0] - b[0])*(a[0] - b[0])
    y = (a[1] - b[1])*(a[1] - b[1])
    return np.sqrt(x+y)
*/
// a is stepper center, b and c are top-bearing center, d is bottom bearing center
// using dist(a, d) above, found that bottom bearing to stepper center is 41.471
// dist(d, c) == 44, dist(a,c) == 54.573


use <bearing.scad>;

// * bearing(pos=[0,0,0], angle=[0,0,0], model=SkateBearing, outline=false, material=Steel, sideMaterial=Brass);

use <motors.scad>;

// * stepper_motor_mount(nema_standard, slide_distance=0, mochup=true, tolerance=0);

use <hardware.scad>;

// * screw(length, nutpos, washer, bearingpos = -1);

use <involute_gears.scad>;

use <auger.scad>;

end_x = 2.5*25.4 + 22 + 20;
end_y = 70;

//localauger();
//setscrew();
//setwheel();
translate([15,15,0])
    setwheel(shaftrad=3/32 * 25.4);
//end_plate();
//end_mold();
//sideplate();
//screwin();
//opb6xx();
/*
translate([- 10, 0, 0])
    biscuit(cutout=0);
translate([- 20, 0, 0])
    biscuit(cutout=0);
*/
//translate([10, 0, 0])
//    biscuit(cutout=1);

module screwin(ang=0, tail=10, nutpos=9, shaft=12){
    rotate([0,0,ang])
    screw(shaft, nutpos, 0, $fn=24);
    translate([0,-5.8/2,-nutpos-2.5])
       cube([tail,5.8,2.5], center=false);
}

module biscuit(rnd=4, length=30, holes=1.6, cutout=0){
    difference(){
        union(){
            for (i=[0,length-rnd*2]){
                translate([0,i,0])
                    cylinder(r=holes, h=22, center=true, $fn=24);
            }
            scale([1+cutout/100, 1+cutout/100, 1+cutout/100])
            hull(){
                cylinder(r=rnd, h=1.2, $fn=36);
                translate([0,length-rnd*2,0])
                    cylinder(r=rnd, h=1.2, $fn=36);
            }
        }
        if (cutout == 0){
            for (i=[0,length-rnd*2]){
                translate([0,i,0])
                    cylinder(r=holes+.05, h=22.1, center=true, $fn=24);
            }
        }
    }
}

module end_plate(x = end_x, y = end_y, thk = 6.9, boltlen=12){
    difference(){
        minkowski(){
        cylinder(.01,1.5,center=false, $fn=20);
        cube([x,y,thk], center=false);
        }
        translate([x/2, 41.4/2, 22]) rotate([180,0,0]){
            #steppercut();
            echo("stepper center at ", [x/2, 41.4/2, 22]);
        }
        
        for (i=[1,-1]){
            translate([x/2 + i*2.5/2*25.4+i*9,13,0]){
                echo("bearing center at ",[x/2 + i*2.5/2*25.4+i*9,13,0]);
                cylinder(r=22.2/2, h=20, center=true, $fn=64);
            }
            translate([x/2 + i*2.5/2*25.4+i*9,y-13,0]){
                echo("bearing center at ",[x/2 + i*2.5/2*25.4+i*9,y-13,0]);
                cylinder(r=22.2/2, h=20, center=true, $fn=64);
            }
            translate([x/2 + i*2.5/2*25.4+i*boltlen/2+i*20,y/2-10,thk/2]) rotate([0,90,90-90*i])
                #screwin(ang=0, tail=10, nutpos=8, shaft=12);
            translate([x/2 + i*2.5/2*25.4+i*boltlen/2+i*20,y/2+10,thk/2]) rotate([0,90,90-90*i])
                #screwin(ang=0, tail=10, nutpos=8, shaft=12);
            translate([x/2 + i*2.5/4*25.4,y+4,thk/2]) rotate([0,-270,90])
                #screwin(ang=0, tail=10, nutpos=8, shaft=12);
            translate([x/2 + i*2.5/4*25.4 + i*5, y-10, thk-1.18]) rotate([0,0,0])
                #biscuit(cutout=1);
        }
    }
}

module end_mold(x = end_x, y = end_y, thk = 7, boltlen=12){
    // a positive for cutting into side-panels
    translate([thk+1, 0, 4]) rotate([0,-90,0]){
    cube([thk,y,thk], center=false);
        for (i=[-1]){
            translate([x/2 + i*2.5/2*25.4+i*boltlen/2+i*20,y/2+10,thk/2]) rotate([0,90,90-90*i])
                    screwin(ang=0, tail=10, nutpos=8, shaft=12);
            translate([x/2 + i*2.5/2*25.4+i*boltlen/2+i*20,y/2-10,thk/2]) rotate([0,90,90-90*i])
                    screwin(ang=0, tail=10, nutpos=8, shaft=12);
        }
    }
}

module opb6xx(
    sensor_bottom_x = 5,
    sensor_bottom_y = 4.6,
    sensor_bottom_z = 1.7,
    sensor_top = [6.35,4.6,3.3]){
        
    sensor_bot = [sensor_bottom_x,sensor_bottom_y,sensor_bottom_z];
    totalsensor_ht = sensor_top[2] + sensor_bottom_z;
        
    for (j=[-1,1]){
        translate([0, j*(y/2 - sensor_bottom_y/2), -8.25]){
            translate([0,0,sensor_bottom_z/2])
                #cube(sensor_bot, center=true);
            translate([0,0,totalsensor_ht/2 + sensor_bottom_z/2- 0.1])
                #cube(sensor_top, center=true);
        cube([sensor_bottom_x, sensor_bottom_y, 16], center=true);
        cylinder(r=sensor_bottom_x/2-0.25, h=17, center=false);  
        }
    }
}

module sideplate(x = 3.5*25.4 + 16 + 50, y = end_y, z = 5){
    // structure
    difference(){
        cube([x,y,z], center=false);
        end_mold();
        translate([x, y, 0]) rotate([0,0,180])
            end_mold();
        for (i=[2/7, 5/7]){
            translate([x/2, y*i, 0]) scale([5,1.18,1]){
                #cylinder(r=y/6, h=z+.1, center=false, $fn=128);
            }
            translate([x*i*0.9, 2.2, 5.7]) rotate([180,0,0])
                #opb6xx();
        }
        for (i=[1,-1], j=[y-10, -10]){
            translate([x/2+i*(x-32)/2, j, z-1.19])
                biscuit(cutout=1);
        }
    }
}

module steppercut(xy=42.3, curve=5.7, tall=20){
    linear_extrude(height=tall)
        minkowski(){
            square([xy-curve, xy-curve], center=true);
            circle(r = curve/2, center=true, $fn=16);
        }
    linear_extrude(height=tall+12)
        stepper_motor_mount(17, slide_distance=0, mochup=true, tolerance=0);
}

module setscrew(nutsq=[6.4,6.4,2.1], bolt=[5.5, 3.75/2], cap=[2.65,6.25/2]){
    translate([-nutsq[0]/2, -nutsq[1]/2, 0])    
        cube(nutsq, center=false);
    cylinder(r=bolt[1],h=bolt[0], center=false, $fn=14);
    translate([0,0,bolt[0]])
        cylinder(r=cap[1], h=cap[0], center=false, $fn=22);
}

module setwheel(shaftrad=7.95/2, nutplay=8.15-2.1, setlen=5.5){
    difference(){
    cylinder(r=shaftrad+setlen, h=6.6, $fn=64, center=true);
    
    // shaft of main
    cylinder(r=shaftrad, h=12, $fn=64, center=true);
    
    rotate([0,90,0]) translate([-.1,0,shaftrad/1.411]) scale([1.01,1,1.2])
        setscrew();
    for (i=[30,150,270]){
        translate([(shaftrad+setlen/2)*sin(i), (shaftrad+setlen/2)*cos(i), -7.1])
            cylinder(r=1.5, h=30, $fn=12, center=false);
    }
    }
}

module localauger(){
    auger(r1 = shaftrad+setlen, r2 = shaftrad+setlen+5, h=20, multiStart=1,
        turns=3, pitch=20,
        flightThickness = 3, overhangAngle=20, supportThickness=0*mm,
        handedness="right" /*"left"*/);
}
    
