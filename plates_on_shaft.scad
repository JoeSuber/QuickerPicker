// plates for rotate-on-shaft idea + openbeam

holespace = 60;
bearingD = 22;
beamside = 15;
// location off-center shaft of beam-hole
db = (holespace + bearingD + beamside) / 2;

cb = 35+ beamside/2;  // shaft center to 608 runners mount-point - a radius of sorts

bigRad = pow((cb*cb) + (db*db), 0.5) + beamside /2;
echo("bigrad = ", bigRad);

use <inside_tracker.scad>;
use <innerds.scad>;
//beamstub();

//pieplate();

//sliphold();
608hold();

module beamstub(ht=30){
    linear_extrude(height=ht)
        import("/home/suber1/Open_Beam_corner_plate_with_optional_foot/Printable_Openbeam/openbeam.dxf");
}

module pieplate(thk=7){
    difference(){
    cylinder(r=bigRad, h=thk, $fn=128, center=true);
        for (i=[1, 0, -1], j=[1,-1]){
            translate([i*db, cb*j, -5])
                scale([1.09,1.09,1])
                    beamstub(ht=30);
            translate([i*db, cb*j, -5])
                scale([0.93,0.93,1])
                    beamstub(ht=30);
            translate([i*db, cb*j, -5])
                scale([1.02,1.02,1])
                    beamstub(ht=30);
        }
        translate([0, 0, -1]){
            cylinder(r=11.1, h=7, $fn=64, center=false);
            cylinder(r=6, h=20, $fn=36, center=true);
        }
        for (i=[0,1]){
        //mirror([0,i,0])
        //    translate([0,cb - beamside, 4]) rotate([-180,90,0])
         //       rotate([0,0,-90])
         //           #cbar(barH=115);
        mirror([i,0,0])
            translate([cb-beamside,6.5,4]) rotate([-180, 180,0])
                #cbar(barH=50);
        }
    }
}


module sliphold(iR=6.1, oR=26.5/2, surround=31/2, h=4.2*2){
    difference(){
        cylinder(r=surround, h=h, $fn=128, center=true);
        cylinder(r=iR, h=h+0.1, $fn=64, center=true);
        cylinder(r=oR, h=h/2+0.1, $fn=96, center=false);
    }
}

module 608hold(iR=6.1, oR=22.6/2, surround=31/2, h=4.2*2, bh=7.2){
        difference(){
        translate([0,0,.5]) union(){
            cylinder(r=surround, h=h+6, $fn=128, center=true);
            scale([1.2,1.1,1])
                cylinder(r=surround, h=h+6, $fn=128, center=true);
        }
        cylinder(r=iR, h=h+5+0.1, $fn=64, center=true);
        translate([0,0,-(h+3)/2])
            cylinder(r=oR, h=50, $fn=96, center=false);
            translate([0,14, 0])
                cylinder(r=1.7, h=50, $fn=20, center=false);
            translate([0,-14, 0])
                cylinder(r=1.7, h=50, $fn=20, center=false);
            translate([-oR-15,0, h+2.5]) rotate([0,90,0])
                scale([1.12,1.12,1])
                    beamstub(ht=80);
            translate([-oR-15,0, h+2.5]) rotate([0,90,0])
                scale([0.90,0.90,1])
                    beamstub(ht=80);
            translate([-oR-15,0, h+2.5]) rotate([0,90,0])
                scale([1.02,1.02,1])
                    beamstub(ht=80);
    }
}

