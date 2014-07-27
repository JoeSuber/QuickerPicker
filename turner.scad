difference(){
translate([0,-47.8,0])
	import("whiskers_small.stl");
cylinder(r=1.8, h=30, center=true, $fn=6);
}
