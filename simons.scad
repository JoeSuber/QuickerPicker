
echo("a box with holes in it for Simon");
// todo: get rid of hard-coded '28' in walls_of_box

bigbox = 80;						// old box was 70?
bigboxht = 55;						// up from 50
fatten_for_lid_cut=0;				// test fit lids: if more than .6 needed, bad geometry or print
									// also, should be zero when printing center section
sides = 2;							// skinny, assumes some further light-stopping material/paint
ledhole=15;	
holeside=ledhole + sides*2 + 10;	// accomodate lense assembly
cornerad=4;						// used with minkowski(), cornerad*2 + 4-flat-sides = perimeter
small_chamber = 1/3;				// total of chambers' ratios should == 1 unless center wall gets thicker
big_chamber = 2/3;				// chambers can be swapped, or center wall can dissapear
slit_width = 5;						// mm
cuvtt_inside = 12;					// put cuvette into a lid, slide detector assm into lid-grooves, put other lid on.
lid_lad = 6;						// basic lid thickness
lid_puff = 4;						// rounded-ness for lid


module walls_of_box(
			fattener=fatten_for_lid_cut,
			longside=bigbox, 
			bigboxht=bigboxht, 
			wallthick=sides,
			ledhole=ledhole,
			cornerad=cornerad,
			holeside=holeside,
			insiders_x=bigbox - sides*3 - cornerad*2,
			insiders_y=ledhole - cornerad,		// inner-wall corner radius is hard-coded at 1/2 of outer
			){
	echo("longside = ", longside);
	echo("insiders_x = ", insiders_x);
	echo("insiders_y = ", insiders_y);
	difference(){
		minkowski(){
			square([longside - cornerad*2, holeside - cornerad*2], center=true);
			circle(r=cornerad+fattener, $fn=36);
		}
		for(block=[[small_chamber*insiders_x - fattener*2, fattener/2], 
					[big_chamber*insiders_x - fattener*2, 28-fattener/2]]){
			echo("block[0] = ", block[0]);
			translate([-longside/2+(wallthick+fattener/2)*2+block[0]/2 + block[1], 0, 0]){
				minkowski(){
					square([block[0], holeside - cornerad - sides*2 - fattener*2], center=true);
					circle(r=(cornerad-fattener)/2, $fn=36);
				}
				// this square is just here to show the light-path
				#square([block[0], slit_width], center=true);
			}
		}
	}
}

module growbox(to_height=bigboxht, slit_width=slit_width, fatboy=0){
	difference(){
		linear_extrude(height = to_height, center = true, convexity = 10, twist = 0, slices = to_height*2, scale = 1){
			walls_of_box(fattener=fatboy+fatten_for_lid_cut);
		}
		cube([bigbox-sides*2-cornerad, slit_width, to_height - 10], center=true);
		for (i=[-bigbox/2, bigbox/2]){
			translate([i,0,0]) rotate([0,90,0])
			#cylinder(r=ledhole/2, h=sides*3, center=true, $fn=128);
		}
	}
}

module lids_on_it (overhang=lid_puff, basethick=lid_lad, with_cuvt=1){
	difference(){
		minkowski(){
			cube([bigbox, holeside, basethick], center=true);
			sphere(r=overhang/2, center=true, $fn=64);
		}
		// imprint the base of the walls and cuvette on a lid-like-structure
		translate([0,0,bigboxht/2])
			growbox(fatboy=.3);
		translate([0,0,bigboxht/2])
			cube([cuvtt_inside+.5, cuvtt_inside+.5, bigboxht], center=true);
		// an extra cut to ensure the lid doesn't obscure the cuvett:
		translate([0,0,bigboxht/2])
			cube([bigbox-sides*4, slit_width-.1, bigboxht], center=true);
	}
}


translate([0,holeside+lid_puff+2,(lid_lad+lid_puff)/2])
	lids_on_it(with_cuvt=1);
translate([0,-(holeside+lid_puff+2),(lid_lad+lid_puff)/2])
	lids_on_it(with_cuvt=0);
translate([0,0,bigboxht/2])
	growbox();




