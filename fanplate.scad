//fan mounting plate
wallcube=[75,65,5];
airway=57;
curve=4;
cp = [0.1,0.1,0.1];

outcube=wallcube+[1.5-curve,1.5-curve,0];
finalcube=outcube+[curve,curve,curve];
echo(outcube, finalcube);

module positive(){
    minkowski(){
        cube(outcube, center=true);
        cylinder(r=curve, $fn=20);
    }
    translate([0,0,outcube[2]/2+3.9])
    import ("../QuickerPicker/faninterface_ring_changed.stl");
    // fan holders
    for (i=[1,-1], j=[1,-1]){
        translate([i*25, j*25, 5])
            cylinder(r=1.92, h=10, center=true, $fn=16);
    }
}

module fanfoundation(wallcut1=3.8, wallcut2=8.1, wallcut_h=1.8){
    
    difference(){
        // raise positive model so wallcuts don't need adjustment
        translate([0,0,outcube[2]/2 - wallcut_h/2])
            positive();
        //wall cuts
        for (i=[1,-1]){
            translate([i*airway/2 + i*wallcut2/2, 0, 0])
                cube([wallcut2, wallcube[1], wallcut_h]+cp, center=true);
            translate([0, i*airway/2 + i*wallcut1/2, 0])
                cube([wallcube[0], wallcut1, wallcut_h]+cp, center=true);    
        }
        // airhole
        cylinder(r=57/2, h=20, $fn=136, center=true);
        // screws
        for (i=[1,-1], j=[1,-1]){
            translate([i*25, j*25, 5]){
                cylinder(r=1.6/2, h=15, center=true, $fn=16);
                //translate([0, 0, -5]) rotate([0,0,sin(30*i)]){
                 //   cylinder(r=6.5/2, h=2.5, center = true, $fn=6);

                //}
            }
        }
        // cone cut from bottom
        translate([0, 0, -(outcube[2]/2 - wallcut_h/2)])
            cylinder(r1=(pow(2,0.5) * 25)-2, r2=airway/2, h=7.1, $fn=128, center=false);
        echo(pow(2,0.5) * 25);
    }
}

fanfoundation();
