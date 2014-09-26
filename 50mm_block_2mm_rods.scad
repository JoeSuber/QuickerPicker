// for spacing rods and using fan-screw-holes as slider bearings

rotate([180,0,0]) rodholder();

module rodholder(alubar_inside=13.15, inside_ht=11, space=40, hole_D=4.5, length=52){
    difference(){
        cube([length, alubar_inside, inside_ht], center=true);
        for (i=[-1,1]){
            translate([space/2*i, 0,-hole_D/2]){
                cylinder(r=hole_D/2, h=inside_ht, $fn=28, center=true);
                translate([0,0,inside_ht/2])
                    sphere(r=hole_D/2, $fn=16, center=true);
            }
            translate([(space/2- hole_D/2 - 1.3)*i, 0,0]) rotate([90,0,0]){
                cylinder(r=1.6, h=alubar_inside+1, $fn=12, center=true);
                translate([0,0, alubar_inside/2 - 1.14])
                    cylinder(r=3.5, h=2.3, $fn=6, center=true);
            }
            translate([3.5*i, 0,0]){
                cylinder(r=1.6, h=inside_ht+1, $fn=28, center=true);
                translate([0,0,-inside_ht/2+1.14])
                    cylinder(r=3.5, h=2.3, $fn=6, center=true);
            }
        }
    }
}

