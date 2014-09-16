// two fan powered picker
use <flatsine.scad>;
//motorbox();
//fancut();
fanbracket();

fansize = 50;
curve = 5;
fanh=15.15;
boarder=3;

screwdistance = fansize - curve*2; 


module elbi (){
	for (i=[0,1]){
		mirror([0,i,0]){
		    translate([0,43,0])
		        elbow();
		translate([0,55,0])
			elbow(tr=3*(6.67+2), thk=5.2);
		}
	}
}

module lifter(s=fanh){
    difference(){
        cube([s,s,s], center=true);
        translate([0,0,-s/2-1-0.1])
            rotate([90,0,0])
                translate([3, 0, -s/2+1.5-0.1])
                linear_extrude(convexity=10, height=s-3)
                    sinewave(portion=180, normto=s/2-1);
        translate([0,0,-0.25*s-0.1])
            cube([s+.1, s+.1, s/2], center=true);
    }
}

module elbow(tr=6.67+2, thk=5, nutthk=2.5){
    translate([0,0,thk/2])
    difference(){
        union(){
            cube([tr, thk, thk], center=true);
            translate([tr/2,tr/2,0]){
                //cube([thk,tr, thk], center=true);
                translate([0,-tr/2,0])
                    cylinder(r=thk, h=thk, center=true);
                translate([-4.3, .5, 0])
                    #cylinder(r=thk/2, h=thk, center=true, $fn=24);
            }
            translate([-tr/2,0,0])
            cylinder(r=thk, h=thk, center=true);
        }
        for (i=[tr/2, -tr/2]){
            translate([i,0,0]){
                cylinder(r=1.7, h=thk+.1, center=true);
                translate([0,0,thk/2-nutthk/2])
                    cylinder(r=6.67/2, h=nutthk+.1, center=true, $fn=6);
            }    

        }
    }
}
               
module motorbox(){
	difference(){
		union(){
			cube([12,10,25.4], center=true);
			cylinder(r=2, h=26.5, $fn=14, center=true);
			translate([0,0,(33.3+26.5)/4])
				cylinder(r=1.7, h=33.3-26.5, $fn=14, center=true);
		}
		translate([0,1.45,(33.3+26.5)/4+1.7])
				cube([3.4, .6, 33.3-26.5], center=true);
	}
}

module fancut(xy=fansize, h=fanh, curve=curve, screwhole_space=screwdistance, screwhole_OD=5){
	minkowski(){
		cube([xy-curve, xy-curve, h-.1], center=true);
		cylinder(r=curve/2, h=.1, $fn=curve*6, center=true);
	}
	cylinder(r=(xy-0.8)/2, h=h+20, center=true, $fn=48);
	for (i=[screwhole_space/2, -screwhole_space/2], j=[screwhole_space/2, -screwhole_space/2]){
        echo("from fancut(), screwhole_OD: ", screwhole_OD);
		translate([i,j,0])
			cylinder(r=screwhole_OD/2, h=h*2, $fn=screwhole_OD*3, center=true);
	}
}

module fanblock(x=fansize*2+boarder*2, y=fansize+boarder*2, h=fanh+1, scl=1.03){
    minkowski(){
	    cube([x-curve, y-curve, h-0.1], center=true);
	    cylinder(r=curve/2, h=0.1, $fn=curve*6, center=true);
    }

}

module fanbracket(x=fansize*2+boarder*2, y=fansize+boarder*2, h=fanh+1, scl=1.011, screwhole_OD=5){
    translate([0,0,h/2])
	 difference(){
        fanblock();
		for (i=[fansize/2*scl, -fansize/2*scl]){
			translate([i,0,1])
			scale([scl,scl,1])
				fancut(screwhole_OD=screwhole_OD);
		}
		translate([0,0,1]) rotate([90,0,0])
			cylinder(r=1.7,h=100, center=true, $fn=12);
		translate([0,0,1]) rotate([90,0,0])
			cylinder(r=3,h=57, center=true, $fn=18);
	}	
}


