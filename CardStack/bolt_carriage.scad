use <hardware.scad>;

// screw(length, nutpos, washer, bearingpos = -1)
//holderflat();
//m3bolt();
translate([46,0,0])
    capture_hollow();
//card(h=.6);
rotate([180,0,90])
    //support();
    tray();
module lmb6uu(){
    // with rod
    difference(){
        union(){
            cylinder(r=3.15, h=70, $fn=28, center=true);
            cylinder(r=6.2, h=19.1, $fn=64, center=true);
        }
        // rings on the bearing:
        for (i=[1,-1]){
            translate([0,0,19.1/4*i])
                difference(){
                    cylinder(r=6.15, h=1.1, $fn=64, center=true);
                    cylinder(r=5.6, h=1.1, $fn=64, center=true);
                }
            }
        }
}

module captured_drive(sep_from_lmb=22/2+4.5, nutht=7){
    // with two nuts
    screwsize = 5/16 * 25.4+.1;
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
                translate([0,14,0])
                    square([20, 44], center=true);
            }
        }
}

module m3bolt(length=24){
    cylinder(r=1.62, h=length, $fn=24, center=true);
    translate([0,0,-length/2])
        cylinder(r=5.8/2, h=2.8, $fn=6, center=false);
    translate([0,0,length/2-2.8])
        cylinder(r=5.8/2, h=2.8, $fn=6, center=false);
}

module rivits(a=22.5, b=33, l=33){
    for (i=[1,-1]){
        rotate([0,90,0]) translate([5*i+1,b,0])
            #m3bolt(length=l);
        rotate([0,90,0]) translate([5*i+1,a,0])
            #m3bolt(length=l);
    }
}
    
module capture_hollow(cutout=true){
    if (cutout==true){
        difference(){
            holderflat();
            #lmb6uu();
            #cube([1.5, 25, 24.5], center=true);
            #captured_drive();
            rotate([0,90,0]) translate([0,-7.8,0])
                #m3bolt(length=26);
            rivits();
        }
    }
    else{
            holderflat();
            #lmb6uu();
            #cube([1.5, 25, 24.5], center=true);
            #captured_drive();
            rotate([0,90,0]) translate([0,-9,0])
                #m3bolt(length=22.1);
            rivits();
    }
}

module card(x=63, y=87.97, curve=2.55, h=17.89/58){
    linear_extrude(height=h){
        minkowski(){
            square([x-curve*2, y-curve*2], center=true);
            circle(r=curve, $fn=36);
        }
    }
    //test size
    //#translate([0,0,-1]) square([x, y], center=true);
}

module support(l= 120, thk=23.4, sections=5, gap=1.5){
    dsqr=(l/sections)+gap;
    start=l/sections;
    intersection(){
        translate([-l/2,0,40]) scale([2.15, 0.614, 1])
            sphere(r=l/2, $fn=64);
        difference(){
            cube([l+gap*(sections), l+gap*(sections), start-.05], center=true);
            for (i=[5:dsqr:l], j=[-2:2]){
                translate([i - l/2, j*dsqr, 0])
                    cube([start, start, start], center=true);
            }
        }
    }
}  

module tray(harden=1.2){
    difference(){
        union(){
            translate([0, 0, 10.78]) rotate([0,0,-90])
                card(h=harden);
            support();
        }
        // IMPORTANT DWELL HERE:
        rotate([0,0,-90]) translate([0, -72.1, 0]) {
            rivits(l=34);
            if (harden==1.2)
                capture_hollow(cutout=true);
            else
                capture_hollow(cutout=false);
        }
    }
}


        
        