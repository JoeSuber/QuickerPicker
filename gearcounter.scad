use <involute_gears.scad>;

//roundbase();
//lettersround();
mirror([0,1,0])
    translate([0,0,3])
        d20rotor(thk=5);
    
mirror([0,0,1]) {
translate([43,0,0])  
    holdergear(braces=10);
translate([-43,0,0])
    holdergear(braces=10);
translate([0,43,0])
    holdergear(braces=10);
}

stddiam = 2.2;
d20 = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20];
dots = [".",".",".",".",".",".",".",".",".",".",".",".",".",".",".",".",".",".",".","."];
d6 = [1,2,3,4,5,6];
bevel_gear_flat = 0;
bevel_gear_back_cone = 1;

module roundbase(diam=stddiam, thk=.8){
	// diam in inches, thk in mm
	rad = diam * 25.4 * 0.5;
	cylinder(r=rad, h=thk, $fn=96);
}

module lettersround(diam=stddiam, thk=2, marks = d20, spinalign="left") {
    deg = 360;
    rad = diam * 25.4 * 0.5 + 1.5;
    for (i=[1:(len(marks))]) {
        j = (i / len(marks)) * deg;
        translate([rad*sin(j), rad*cos(j), 0])
            rotate([0,0,90 - j])
                linear_extrude(height = thk) {
                    text(text=str(marks[i-1]), font="Arial Black", size=rad*0.25, valign="center", halign=spinalign);
                }
    }
}

module d20rotor (diam=stddiam*1, thk=1, overall_thk=9) {
    difference(){
        union(){
        translate([0,0,-overall_thk*0.5])
            bevel_gear(	number_of_teeth=40,
                        cone_distance=150,
                        face_width=6,
                        outside_circular_pitch=267,
                        pressure_angle=23,
                        clearance = 0.2,
                        bore_diameter=18,
                        gear_thickness = overall_thk,
                        backlash = 0,
                        involute_facets=1,
                        finish = -1);

        }
        translate([0,0,-0.1]){
            // cut out the alpha-marks:
            lettersround(diam=diam*.72, thk=thk*2, spinalign="center");
            // cut out the dots:
            lettersround(diam=stddiam*0.44, thk=thk*2, marks = dots);
            // hub-hole cut-out
            translate([0,0,-thk*.6]) 
                cylinder(r = 22 * 0.5, h = thk*2, $fn=72, center=false);
            translate([0,0,-thk*3.1]) 
                cylinder(r = 18 * 0.5, h = thk*6, $fn=72, center=false);
        }
    }
}

// Two gears with the same cone distance, circular pitch (measured at the cone distance)
// and pressure angle will mesh.

module holdergear (diam=stddiam*1, thk=1, overall_thk=9, braces=10) {
        bevel_gear_back_cone = 1;
        translate([0,0,-overall_thk*0.5])
            difference(){
                bevel_gear(	number_of_teeth=braces,
                            cone_distance=150,
                            face_width=6,
                            outside_circular_pitch=267,
                            pressure_angle=23,
                            clearance = 0.2,
                            bore_diameter=3,
                            gear_thickness = overall_thk,
                            backlash = 0,
                            involute_facets=1,
                            finish = -1);
                cylinder(r=3.8, h=4, $fn=6, center=true);
            }
}



