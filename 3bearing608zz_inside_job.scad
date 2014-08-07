use <inside_tracker.scad>;

// for printing the insider all by itself

translate([0,0,-10])
    inside_job(give=.5, ht=30, ringthk=6, 
                    bearoutrad = 11.15, 
                    bearin_spinrad = 13.28/2,
                    bear_shaft_outrad = 8/2);
