// giving in to the gears

cardsize=[88,63];

//motor(wireang=30);
//translate([0,0,-0.5]) scale([1,.5,1]) #card();
//translate([0,0,1.5]) scale([.5,1,1]) #card();


tray();
translate([0,0,-12]) rotate([0,180,0])
	fanbracket();
translate([0,0,0]) rotate([0,0,0])
	sensor();

use </home/suber1/QuickerPicker/twofan.scad>;

module sensor(cutpins=30, cutscale=[1,1,1] ){
	translate([-3.03,+2.21,0]) rotate([90,0,0])
		linear_extrude(convexity=10, height=4.42){
			polygon(points=[[0,0], [0,3], [(6.06-4.81)/2, 3], [(6.06-4.81)/2, 4.64], [5.05, 4.64], [5.05, 3], [6.06,3], [6.06,0]]);
		}
	for(i=[1,-1], j=[1,-1]){
		translate([i*2.3/2, j*2.1/2, -cutpins/2])
			cylinder(r=.9, h=cutpins, $fn=4, center=true);
	}
}

module shaft(ht=7.47, dn=2.96, flat=2.45){
	difference(){
		cylinder(r=dn/2, h=ht, $fn=20);
		translate([(2.96+2.45)/4, 0, ht/2])
			#cube([(2.96-2.44)*20, 0, ht+0.1], center=true);
	}
}

module motor (wires=40, wireang=90, motor=14.62){
	for (i=[4,-4]){
		translate([-4,i,1.75]) rotate([90,0,wireang]) 
			cylinder(r=1.75, h=wires, $fn=6, center=false);
	}
	translate([0,0,2]){
		cylinder(r=2.5, h=1, $fn=16, center=false);
		cube([2,12,2], center=true);
		translate([0,0,1])
			difference(){
				cylinder(r=6, h=motor, $fn=36);
				for (i=[-1,1]){
					translate([6*i,0,motor/2])
						cube([2,12,motor+0.1], center=true);
				}
			}
		translate([0,0,motor+1+9.16/2])
			cube([10,12,9.16], center=true);
		translate([0,0,motor+1+9.16])
			cylinder(r=2, h=(24.96-24.28), $fn=16);
		translate([0,0,motor+1+9.16+(24.96-24.28)])
			shaft();
	}
}

module card (xy=[88,63], corner=2.69){
	minkowski(){
		square([xy[0]-corner*2, xy[1] - corner*2], center=true);
		circle(r=corner, $fn=36);
	}
}

module tray_block(scaler=1.25, startscale=[1,1,1], ht=10){
	linear_extrude(convexity=10, height=ht, scale=scaler){
		scale(startscale)
			card();
	}
}

module tray(){
	x = cardsize[0]/10 - 0.5;
	y = cardsize[1]/10 - 0.7;
	difference(){
		union(){
			tray_block(scaler=1.15, startscale=[1.1,1.1,1], ht=11.9);
			tray_block(scaler=1, startscale=[1.3, 0.8777, 1], ht=11.9);
			tray_block(scaler=1, startscale=[0.5, 1.3, 1], ht=11.9);
			difference(){
				translate([0,0,-1]) rotate([0,180,0])
					fanbracket();
				translate([-(x+.5)*5, -(y+.7)*5, -13])
					#cube([88,63,15]);
			}
		}
		translate([0,0,2])
			tray_block();
		for (i=[0:cardsize[0]/10:cardsize[0]], j=[cardsize[1]/10:cardsize[1]/10:cardsize[1] - cardsize[1]/10]){
			translate([i-cardsize[0]/2,j-cardsize[1]/2,1.5])
				cube([x,y,3], center=true);
		}
	}
	
}

	
		
	
