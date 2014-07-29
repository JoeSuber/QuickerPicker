
echo("608zz_run_free - cones for thread return on 608zz bearing");
// my_bearing_cutter() is for cutting into other stuff, not otherwise representing
$fn=128;


module my_bearing_cutter(
shaftlen=20, 
wholeH=7.1, 
bevel=.55, 
outD=22.15, 
outwall_thk=2.3, 
inspinD=12.6, 
inspinID=8,
inspincut=1.5,
){
	// bevel on outside perimeters
	difference(){
		union(){
			translate([0,0,-(wholeH / 2)+bevel/2])
				cylinder(r1=(outD-bevel*2)/2, r2=outD/2, h=.5, center=true);
			translate([0,0,wholeH / 2 - bevel/2])
				cylinder(r1=outD/2, r2=(outD-bevel*2)/2, h=.5, center=true);
		}
		cylinder(r=(outD-bevel*2)/2, h=wholeH+.2, center=true);
	}
	//outside running surface and body
	cylinder(r=outD/2, h=wholeH-1, center=true);
	// post-bevel rim
	difference(){
		cylinder(r=(outD-bevel*2)/2, h=wholeH, center=true);
		cylinder(r=(outD - outwall_thk)/2, h=wholeH+.2, center=true);
	}
	// slightly fatter-than-reality insiderim
	difference(){
		cylinder(r=inspinD/2, h=wholeH+inspincut, center=true);
		cylinder(r=inspinID/2, h=wholeH+inspincut, center=true);
	}
	if (shaftlen > 0){
		#cylinder(r=inspinID/2, h=shaftlen, center=true);
	}
}

module freewheel (outsideD=28, sidewallthk=1.2, shaftage=8, bearingH=7.1){
translate([0,0,+bearingH/2])
	difference(){
		translate([0,0,-bearingH/2+sidewallthk])
			cylinder(r1=outsideD/2, r2=22.15/2, h=sidewallthk+bearingH/2, center=true);
		translate([0,0,0])
			my_bearing_cutter();
	}
	echo("freewheel half");
}

module freewheel_model (shaft=30, spacebear=7.1/2){
	for(i=[90,-90]){
		translate([0,spacebear*i/abs(i),0]) rotate([i,0,0])
			freewheel(shaftlen=shaft/2);
	}
}


// print (in two halves) a snug fitting pully
// so that thread runs on steel

module print_freewheel(){
	translate([0,-(30+1)/2,0])
		freewheel();
	translate([0,(30+1)/2,0])
		freewheel();
}

//freewheel_model();

print_freewheel();

//my_bearing_cutter();
