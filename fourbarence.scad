// bars for making 4-bar motion setups

use <innerds.scad>;

wall=10;  // distance across flat a.k.a width
thickness = 2.6; //depth of thing as it lays on a plate
holespace = 6; //mechano spacing =6mm
rod_d = 3.25; // m3 with fudge for printing hole=3.25
nut_d = 6.67; // m3 hex nut diameter w/ fudge
nut_sqr = 7.5; // mechano square nuts

for (i=[0,1], j=[0:13:13*2]){
mirror([0,i,0]) translate([j,13,13.65]) rotate([270,0,0])
    c_channel_end();
}
nuttin(h=4, hex=0, nut_sqr=6.4*pow(2,0.5));

//screwee();
//hanger();
//manybar(numbar=4, barcrement=18);
//manybar(numbar=4, barcrement=18, m=1);

module nuttin (h=thickness, hex=6.67, nut_sqr=nut_sqr, hexh=max([2.2, thickness/2+.1])){
    cylinder(r=rod_d/2, h=h, $fn=12);
    if (hex > 0){
    translate([0,0,h/2])
        cylinder(r=hex/2, h=hexh, $fn=6);
    }
    else if (nut_sqr > 0){
    translate([0,0,h/2])
        cylinder(r=nut_sqr/2, h=hexh, $fn=4);
    }
}

module squarenuts (){
    motor();
}

module flatbar(r=wall/2, r2r=10, loc=0){
    translate([0,loc,0]){
        hull(){
            circle(r=r, $fn=r*5);
            translate([r2r, 0, 0])
                circle(r=r, $fn=r*5);
        }
    }
}

module growbar(r2r=10, loc=0){
    total_len=r2r+holespace;
    difference(){
        linear_extrude(convexity=10, height=thickness){
            flatbar(r=wall/2, r2r=r2r, loc=loc);
        }
        for (i=[0:holespace*2:total_len - wall/2.5])
            translate([i, loc, -0.05])
                nuttin();
    }
}

module manybar(numbar=6, barcrement=18, m=0){
    mirror([m,0,0]) translate([holespace*2,0,0])
    for (i=[barcrement: barcrement: numbar*barcrement]){
        growbar(r2r=i, loc=numbar*(wall+1) - i/barcrement*(wall+1));
    }
}

module hanger(){
    translate([0,-30, 0]){
        growbar(r2r=48);
        translate([24,0,0]) rotate([0,0,90])
            growbar(r2r=12);
    }
}

module c_channel_end(){
    difference(){
        translate([0,7.6,5.5])
        cube([12,12,11], center=true);
        translate([0,8,11])
        nutbolt(channel_ang=90);
        cbar(bar_h=12);
    }
}

