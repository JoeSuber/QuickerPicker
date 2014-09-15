// ideas about the parts needed for the current simplest implementation

/*
1 - picker using 2 50mm square sunon fans drawing 42ma @12v each - 1 watt
    a) carriage for fans needs to lift off for card release and return to...
    b) surrounding body should center card, hold lifting cams or whatever and have ir sensor(s) for card-in-place.
        perhaps also ultrasonic for distance and/or laser dot/cross for camera-directed placement. Use small stepper for lift
    c) a) & b) assembly should ride on 'screwless' lifter part which fits into...
    d) top & bottom mount for smooth rod and square tube. May be symetrical. 'Big Mac' of base, stepper-top, top-top.
        May include drive step-motor on perimeter for rotation.
        May be light enough for vertical translation via buehler lead-screw.  Holds heavy stepper as base of rotating shaft.
    e) shaft coupler should fit onto array of steppers already geared and include set-screws in symetrical captured-nut system
    f) stationary base for rotating d)

*/

use </home/suber1/openscad/libraries/MCAD/involute_gears.scad>;
use </home/suber1/openscad/libraries/MCAD/screw.scad>;
bigrad=20;
bigh = 28.5;
nutter= 12.65;
nuthut = 5.73;
bolt = 6.3;

//nutty();
//geartop();
//sample_to_fit();

//translate([0,0,bigh]) rotate([180,0,0])  coupleit();

//$fn=16;  screwdrive();
//translate([0,20,0])
 //   screwee();

//nema23neg();
//rotate([0,180,0]) translate([0,0,-1.5]) powerplate();

trackwheel();

module geartop (){
difference(){
    cylinder(r=bigrad, h=bigh, center=false, $fn=128);
    gear(number_of_teeth=19,
	    circular_pitch=30.95*3.141592654*3.141592654, diametral_pitch=false,
	    pressure_angle=28,
	    clearance = 0.2,
	    gear_thickness=14,
	    rim_thickness=14,
	    rim_width=5,
	    hub_thickness=14,
	    hub_diameter=14,
	    bore_diameter=0,
	    circles=0,
	    backlash=0,
	    twist=0,
	    involute_facets=1,
	    flat=false);
}
}

module sample_to_fit(ht=1){
    // a slice of the gear for testing fit
    difference(){
    geartop();
    translate([0,0,50+ht])
        cube([100,100,100], center=true);
    }
}

module nutty(nutrad=nutter/2, boltrad=bolt/2){
    // cuts out the captured nut & bolt channels
    translate([0,0,0]) rotate([90,0,0]) {
        hull(){
            cylinder(r=nutrad, h=nuthut, $fn=6, center=false);
            translate([0,bigh,0])
                cylinder(r=nutrad, h=nuthut, $fn=6, center=false);
        }
        cylinder(r=boltrad, h=bigrad, $fn=36, center=false);
    }
}

module coupleit(shaft=8.25, nuthold=nutter){
    //couple belt-gear (that was glued into place) with shaft for direct rotation
    difference(){
        geartop();
        cylinder(r=shaft/2, h=80, $fn=128, center=true);
        for (i=[0,120,240]){
            translate([(bigrad/4)*cos(i),(bigrad/4)*sin(i), bigh - nuthold/2-2])
                rotate([0,0,i+90])
                    #nutty();
        }
    }
}

module screwdrive(ptch=11, ht=40, diam=11, balz=2.25, fat=0){
    bigbalz = balz+fat;
    cylinder(r=diam/2, h=ht+balz, center=false, $fn=36);
    translate([0,0,balz/2])
        for (i=[0,120,240]){
            rotate([0,0,i])
                ball_groove2(ptch, ht, diam, bigbalz/2, slices=300);
        }
}

module screwee(){
    difference(){
        cylinder(r=10, h=10, $fn=6);
        translate([0,0,-10])
            screwdrive(fat=.1);
    }
}

module nema23neg(out=56.4, holesep=47.14, roundplate=38.1, platethick=4.76, roundthick=1.59, corner_rnd=4, screwhole=5.08, shaft=6.38, fat=0){
    fout=out - corner_rnd*2;
    hh=holesep/2;
    sh=screwhole/2;
    shft=shaft/2;
    minkowski(){
        cube([fout+fat, fout+fat, platethick], center=true);
        cylinder(r=corner_rnd, h=.1, $fn=12, center=true);
    }
    translate([0,0,platethick/2+ roundthick/2])
        cylinder(r=roundplate/2+fat/2, h=roundthick, $fn=128, center=true);
    for (i=[hh,-hh], j=[hh,-hh]){
        translate([i,j,0])
        cylinder(r=sh, h= 30, $fn=16, center=true);
    }
    cylinder(r=shft+fat/2, h=46, $fn=24, center=true);
}

module sqrbar(ht=100, out=25.4*0.75, wall=2, fat=0){
    linear_extrude(convexity=10, height=ht){
        difference(){
            square([out+fat/2,out+fat/2], center=true);
            square([out-wall*2-fat/2, out-wall*2-fat/2], center=true);
        }
    }
}

module powerplate(thk=3, short=80, long=90, rnd=5){
    difference(){
        minkowski(){
            cube([long-rnd*2, short-rnd*2, thk], center=true);
            cylinder(r=rnd, h=.1, $fn=18, center=true);
        }
        translate([-long/6, 0, -thk/2])
            nema23neg(fat=.1);
        translate([long/2-12.5, 0, -10])
            #sqrbar(fat=.1);
    }
}

module trackwheel(){
    difference(){
        cylinder(r=23/2, h=5, $fn=6, center=false);
        cylinder(r=12.5/2, h=5.1, $fn=128);
    }
    translate([0,0,2.5]){
        for (i=[0,120,240]){
            translate([6.25*cos(i), 6.25*sin(i), 0])
                sphere(r=1.3, $fn=18, center=true);
        }
    }
}

module servo_hd(){
    shafth=48;
    shaftabove=10;
    shaftD=9.9;
    armlen=29.9;
    shaftcircles=[11,14];
    circ_to_square_len = 34.96;
    circ_to_square_width = 18.75;
    circ_to_square_height = 1.85;
    boxh = 36.5;
    boxw = 20.3;
    boxlen=40.25;
    tab_thk = 2.5;
    tab_w = 18.65;
    tab_len = 7.17;
    armwidth=12.25;
}

