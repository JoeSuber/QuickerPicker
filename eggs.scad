// stopper and cutter for air-holes
use <gear_ups.scad>;
use <faninterface_ring.scad>;

//rotate([90,0,0]) mbox(mb=62.5);

degrees = 360;
parts = 6;
stopper_rad = 7;
roundwall = 57.36;
stretch = 1.67;

// disk in-place
//translate([0,0,stopper_rad])
	//cylinder(r=roundwall/2, h=1, center=true, $fn=64);

module stopper_eggs(st=stretch, 
			fatten=1.04, 
			deg=degrees, 
			p=parts, 
			sr=stopper_rad, 
			upbump=3,
			ODrnd=roundwall){
echo("zstretch on stopper footballs is = ", st*sr);
echo("fatten = ", fatten, " Use fatten for cut into roof");
//stopper parts
	// center egg
	translate([0,0,upbump]) scale([fatten,fatten,st])
		sphere(r=sr, $fn=36);
	// circle of eggs
	for (i=[0:deg/p: deg-deg/p*.5]) {
		translate([ODrnd/3.1415*cos(i), ODrnd/3.1415*sin(i), upbump]){
		scale([fatten,fatten,st])
			sphere(r=sr, $fn=36);
		translate([0, 0, -st*sr/2-upbump*2+.2]) rotate([0,0,i])
			cube([ODrnd/6, 1, st*sr + upbump]);
		// connective tissue
		translate([-ODrnd/3.1415*cos(i)/2, -ODrnd/3.1415*sin(i)/2, -st*sr+upbump/2])
			volcano(inside=ODrnd/3.1415, based=ODrnd/3.1415+1.1, ht=st*sr*.25);
		}
	}
	// holder for printing
	translate([0,0, -st*sr/2-upbump/2+.1])
	rotate([180,0,0])
	volcano(inside=ODrnd/3.1415*2, based=ODrnd/3.1415*2+2.5, ht=st*sr*.25);
	translate([0,0, -st*sr/2+upbump/2])
	volcano(inside=ODrnd/3.1415*2, based=ODrnd/3.1415*2+2.5, ht=st*sr*.25);
}

module stopper_egg_basket(){
	stopper_eggs(p=7);
}

stopper_egg_basket();