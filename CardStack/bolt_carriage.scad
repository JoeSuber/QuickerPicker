use <hardware.scad>;

// screw(length, nutpos, washer, bearingpos = -1)
//holderflat();
//m3bolt();

//capture_hollow();
//card();
//support();
tray();
module lmb6uu(){
    // with rod
    difference(){
        union(){
            cylinder(r=3.1, h=70, $fn=28, center=true);
            cylinder(r=6.1, h=19, $fn=64, center=true);
        }
        // rings on the bearing:
        for (i=[1,-1]){
            translate([0,0,19/4*i])
                difference(){
                    cylinder(r=6.15, h=1.1, $fn=64, center=true);
                    cylinder(r=5.6, h=1.1, $fn=64, center=true);
                }
            }
        }
}

module captured_drive(sep_from_lmb=22.1/2+6.1+1, nutht=7){
    // with two nuts
    screwsize = 5/16 * 25.4;
    echo("separation between centers of screw-nuts and lmb", sep_from_lmb);
    translate([0, sep_from_lmb, 35]){
        screw(70, 35-10.5, 0, bearingpos = -1, $fn=24);
        screw(70, 35+7.5, 0, bearingpos = -1);
    }
}

module holderflat(){
    translate([0,0,-12])
    linear_extrude(height=21.45){
            minkowski(){
                circle(r=2, $fn=36);
                translate([0,10,0])
                    square([18, 40], center=true);
            }
        }
}

module m3bolt(length=18){
    cylinder(r=1.62, h=length, $fn=24, center=true);
    translate([0,0,-length/2])
        cylinder(r=5.8/2, h=2.8, $fn=6, center=false);
    translate([0,0,length/2-2.8])
        cylinder(r=5.8/2, h=2.8, $fn=6, center=false);
}

module rivits(a=8, b=28, l=24.1){
    for (i=[1,-1]){
        rotate([0,90,0]) translate([5*i+1,b,0])
            #m3bolt(length=l);
        rotate([0,90,0]) translate([5*i+1,a,0])
            #m3bolt(length=l);
    }
}
    
module capture_hollow(){
    difference(){
        holderflat();
        #lmb6uu();
        #cube([1.5, 25, 24.5], center=true);
        #captured_drive();
        
        rotate([0,90,0]) translate([0,-9,0])
            #m3bolt(length=22.1);
        rivits(a=8, b=28, l=24.1);
    }
}
module card(x=63, y=87.97, curve=2.98, h=17.89/58){
    linear_extrude(height=h){
        minkowski(){
            square([x-curve*2, y-curve*2], center=true);
            circle(r=curve, $fn=36);
        }
    }
    //test size
    #translate([0,0,-1]) square([x, y], center=true);
}

module support(l= 110, thk=23.4, sections=4, gap=1.5){
    dsqr=(l/sections)+gap;
    start=l/sections;
    intersection(){
        translate([-l/2,0,40]) scale([2.5,1,1])
            sphere(r=l/2);
        difference(){
            cube([l+gap*(sections), l+gap*(sections), start-.05], center=true);
            for (i=[0:dsqr:l], j=[-2:2]){
                translate([i - l/2, j*dsqr, 0])
                    cube([start, start, start], center=true);
            }
        }
    }
}  

module tray(){
    translate([0, 90, 0])
        card(h=1.2);
    support();
}
    
        
        