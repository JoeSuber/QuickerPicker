//motorbox();
//fancut();
fanbracket();

fansize = 60;
curve = 5;
fanh=12;
boarder=3;

screwdistance = fansize - curve; 

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

module fancut(xy=fansize, h=fanh, curve=curve, screwhole_space=50, screwhole_OD=5){
	minkowski(){
		cube([xy-curve, xy-curve, h-.1], center=true);
		cylinder(r=curve/2, h=.1, $fn=curve*6, center=true);
	}
	cylinder(r=(xy-0.8)/2, h=h+20, center=true, $fn=48);
	for (i=[screwhole_space/2, -screwhole_space/2], j=[screwhole_space/2, -screwhole_space/2]){
		translate([i,j,0])
			cylinder(r=screwhole_OD/2, h=h*2, $fn=screwhole_OD*3, center=true);
	}
}

module fanbracket(x=fansize*2+boarder*2, y=fansize+boarder*2, h=fanh+1, scl=1.03){
	 difference(){
		 minkowski(){
			cube([x-curve, y-curve, h-.1], center=true);
			cylinder(r=curve/2, h=.1, $fn=curve*6, center=true);
		}
		for (i=[fansize/2*scl, -fansize/2*scl]){
			translate([i,0,1])
			scale([scl,scl,1])
				fancut();
		}
	}	
}
