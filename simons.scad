
echo("a box with holes in it for Simon");
// todo: get rid of hard-coded '28' in walls_of_box

bigbox = 80;						// old box was 70?
bigboxht = 55;						// up from 50
fatten_for_lid_cut=.2;				// test fit lids: if more than .6 needed, bad geometry or print
									// also, should be zero when printing center section
sides = 2;							// skinny, assumes some further light-stopping material/paint
ledhole=5;
sensorhole=15;
fingerspace=37;	
holeside=sensorhole + sides*2 + fingerspace;	// accomodate lense assembly
cornerad=4;						// used with minkowski(), cornerad*2 + 4-flat-sides = perimeter
small_chamber = 1/3;				// total of chambers' ratios should == 1 unless center wall gets thicker
big_chamber = 2/3;				// chambers can be swapped, or center wall can disappear
slit_width = 5;						// mm
cuvtt_inside = 12.1;					// put cuvette into a lid, slide detector assm into lid-grooves, put other lid on.
lid_lad = 5;						// basic lid thickness
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
			insiders_y=holeside - cornerad,		// inner-wall corner radius is hard-coded at 1/2 of outer
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
		// cut the slot for cuvette illumination
		translate([0,0,-5])
			cube([bigbox-sides*2-cornerad, slit_width, to_height - 5], center=true);
		// cut the holes for LED & sensor
		for (i=[[-bigbox/2, sensorhole], [bigbox/2, ledhole]]){
			translate([i[0],0,0]) rotate([0,90,0])
			#cylinder(r=i[1]/2, h=sides*3, center=true, $fn=32);
		}
	}
}

module lids_on_it (overhang=lid_puff, basethick=lid_lad, fatmaker=.35){
	difference(){
		minkowski(){
			cube([bigbox, holeside, basethick], center=true);
			sphere(r=overhang/2, center=true, $fn=32);
		}
		// imprint the base of the walls and cuvette on a lid-like-structure
		translate([0,0,bigboxht/2])
			growbox(fatboy=fatmaker);
		translate([0,0,bigboxht/2])
			cube([cuvtt_inside+.5, cuvtt_inside+.5, bigboxht], center=true); 
		// an extra cut to ensure the lid doesn't obscure the cuvett:
		//translate([0,0,bigboxht/2])
		//	cube([bigbox-sides*4, slit_width+.1, bigboxht], center=true);
		if (fatmaker > 0){
			translate([-11,0,bigboxht/2])
				#cube([3,5,bigboxht], center=true);
		}
	}
}


translate([0,holeside+lid_puff+2,(lid_lad+lid_puff)/2])
	lids_on_it();
translate([0,0,(lid_lad+lid_puff)/2])
	lids_on_it(fatmaker=0);
translate([0, 0, (lid_lad+lid_puff)/2 + bigboxht/2])
	growbox();




