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
bigrad=20;
bigh = 28.5;
nutter= 12.65;
nuthut = 5.73;
bolt = 6.3;

//nutty();
//geartop();
//sample_to_fit();

translate([0,0,bigh]) rotate([180,0,0])  coupleit();


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

