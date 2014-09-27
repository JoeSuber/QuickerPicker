// a cylinder with a bump on the outside
// used for translating a sleeve up and down using 
// unidirectional rotation

use <inside_tracker.scad>;

// vertical motion from grooves

// horizontal stopped by bar connected to outside/top

intrack=29;
boltd=6.07; //  1/4in smooth shaft bolt

module patern(thk=1.5){
    difference(){
        circle(r=intrack, $fn=128);
        translate([(-boltd/2)/2 - thk/2, 0,0])
            circle(r=intrack-boltd/2, $fn=128);
        translate([intrack-thk-boltd/2, 0,0])
            circle(r=boltd/2, $fn=18);
    }
}

//patern(thk=1.5);


module fixerup (ht=30.2, midpart=4, thkk=1.2, srd=3){
     translate([(intrack-1)*cos(180 * srd / intrack), (intrack-1)*sin(180 * srd / intrack), ht/2]) rotate([0,0,180 * srd / intrack])
        sphere(r=srd, $fn=32);
    difference(){
        linear_extrude(height=ht, convexity=10){
            patern(thk=thkk);
        }
        for(i=[[0,0], [ht, -1]]){
            translate([0,0,i[0]-.1])  rotate([180*i[1], 0,0])
                cylinder(r1 = intrack - 1, r2 = intrack - boltd/2 - thkk*2, h=ht/2 - midpart/2+.1);
        }
    }
}
translate([0,0,30]) rotate([180,0,0]) 
    fixerup();
