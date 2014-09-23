// combine several parts to see how they fit

use <fanplate.scad>;
use <gearlift.scad>;
use <innerds.scad>;
use <twofan.scad>;
use <armsrace.scad>;
use <needs_for_simple.scad>;

translate([0,0,4])
	cbracket();

translate([0,98,50*$t]) rotate([0,0,90])
	fanbracket();

translate([60,0,0])
	bigwheel_part();
	
translate([0,98,-12]) rotate([0,180,90])
    tray();

//motorbox();
	
module bottom_plate(){
	projection(cut = true){
translate([0,86,50*$t-0.5]) rotate([0,0,90])
	fanbracket();
	}
}
