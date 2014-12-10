// stackable trays bolt together
// topper narrows to exact card size for camera positioning
// IR sensor positions allow mcu to adjust card height
// screw drive allows stepper disable to reduce power/heat
// 100lb test thread x 4 for lifting

use <bearing.scad>;

// * bearing(pos=[0,0,0], angle=[0,0,0], model=SkateBearing, outline=false, material=Steel, sideMaterial=Brass);

use <motors.scad>;

// * stepper_motor_mount(nema_standard, slide_distance=0, mochup=true, tolerance=0);

use <hardware.scad>;

// * screw(length, nutpos, washer, bearingpos = -1);

use <involute_gears.scad>;

end_x = 2.5*25.4 + 22 + 20;
end_y = 70;

end_plate();
//end_mold();
//sideplate();
//screwin();
//opb6xx();
translate([- 10, 0, 0])
    biscuit(cutout=0);
translate([- 20, 0, 0])
    biscuit(cutout=0);
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
        translate([x/2, 41.4/2, 22]) rotate([180,0,0])
            #steppercut();
        
        for (i=[1,-1]){
            translate([x/2 + i*2.5/2*25.4+i*9,13,0])
                cylinder(r=22.2/2, h=20, center=true, $fn=64);
            translate([x/2 + i*2.5/2*25.4+i*9,y-13,0])
                cylinder(r=22.2/2, h=20, center=true, $fn=64);
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

module sideplate(x = 4.1*25.4, y = 70, z = 5){
    // structure
    difference(){
        cube([x,y,z], center=false);
        end_mold();
        translate([x, y, 0]) rotate([0,0,180])
            end_mold();
        for (i=[2/7, 5/7]){
            translate([x/2, y*i, 0]) scale([3.6,1.18,1]){
                #cylinder(r=y/6, h=z+.1, center=false, $fn=128);
            }
            translate([x*i, 2.2, 5.7]) rotate([180,0,0])
                #opb6xx();
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
