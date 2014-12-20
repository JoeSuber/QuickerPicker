use <bearing.scad>;

// * bearing(pos=[0,0,0], angle=[0,0,0], model=SkateBearing, outline=false, material=Steel, sideMaterial=Brass);

use <motors.scad>;

// * stepper_motor_mount(nema_standard, slide_distance=0, mochup=true, tolerance=0);

use <hardware.scad>;
// * screw(length, nutpos, washer, bearingpos = -1);

use <bolt_carriage.scad>;

//plateprint();
translate([88, 0, 0])
    headprint();


module plateprint(){
    difference(){
        bottom();
        translate([0, -1*25.4, 0]){
            footprint();
            //translate([0, .25*25.4, 6])
               // cardsize();
        }
    }
}

module headprint(){
    difference(){
        plateprint();
        translate([0,-12,20]) rotate([180,0,-90]) scale([1.015,1.015,1]) tray(harden=20);
        rotate([90,0,0]) translate([31,2.2,7]) rotate([0,90,0]) #opb6xx();
    }
}


module footprint(sprd=3.365*25.4){
    rotate([0, 180, 0]) translate([0, 0, -23])
        steppercut();
    // bearing and smooth-rod placement:
    translate([0,sprd-15.5, 1.5]){
        #cylinder(r=22.25/2, h=4.6, $fn=64);
        translate([0,0,-1.6])
            #cylinder(r=16/2, h=8, $fn=64);
    }
    translate([0,sprd, 2])
        #cylinder(r=3.24, h=5, $fn=64);
    
    //corner bolt-rods:
    for (i=[-1, 1], j=[-1, 1]){
        translate([i*2.8*25.4/2, j*4.8*25.4/2+25.4,0]){
            #cylinder(r=.255*25.4/2, h=20, $fn=36, center=true);
            translate([0,0,3.5])
                #cylinder(r=12.7/2, h=7, $fn=6, center=false);
        }
    }
}

module bottom(thk=.6){
        linear_extrude(height=6){
            minkowski(){
                circle(r=5, $fn=24);
                square([3*25.4, 5*25.4], center=true);
            }
        }
        for (i=[33,-33]){
         rotate([90,0,90]) translate([0,6.5,i])
            scale([9,1,1])
                cylinder(r=13/2, h=1.8, $fn=64, center=true);
        }
}

module steppercut(xy=42.3, curve=5.7, tall=20, slider=20){
    linear_extrude(height=tall)
        minkowski(){
            square([xy-curve, xy-curve+slider], center=true);
            circle(r = curve/2, center=true, $fn=16);
        }
    linear_extrude(height=tall+12)
        stepper_motor_mount(17, slide_distance=slider, mochup=false, tolerance=0);
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