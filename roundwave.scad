
// circular cam generator
// use cubes to make a smooth circular arangement of bumps

outsiderad = 34;
insiderad = 31;
pi = 3.141592653589793;
thickness = outsiderad - insiderad;
spot = insiderad + thickness / 2;
circumf = outsiderad * 2 * pi;
div = 3;							// wave 'peaks' or bumps around the perimeter of the circle
lift = 6;  						// zero-to-apex-or-trough i.e. size of bumps
detail = 200;					// how many divisions in a bump-block (aka div), i.e. resolution				
ranger = 360*div;				// how many degrees of a circle to represent
part_circle = ranger/360 * circumf;
bit = part_circle / ranger;
deg_in_detail = bit/part_circle * 360;



module hump (div=div, 
			ranger=ranger,
			lift=lift,
			detail=detail,
			spot=(insiderad+outsiderad)/2,
			thickness=thickness,
			base=1.5){
	for (i=[1 : (1/detail)*ranger : ranger]){
		translate([cos( i/div) * spot, sin( i/div) * spot, (lift + lift*sin(i))/2]) 
		rotate([0,0, i/div])
			scale([1, 1, 1])
			cube([thickness, (1/detail) * part_circle, base+ (lift + lift*sin(i))], center=true);
	}
}

module roller (div=div, ranger=ranger, lift=lift, detail=detail, thickness=thickness, sc=[1,1,1], base=1.5){
			scale(sc)
				hump(div=div, ranger=ranger, lift=lift, detail=detail, thickness=thickness+1, base=1.5);
}

module springpart(wirethick=1.5, scaleofcut=0.92){
	difference(){
		hump();
		translate([0,0,-wirethick])
			roller(sc=[1,1,scaleofcut]);
	}
}

module sprang(stacks=1, howhigh=12) {
	for (i=[0 : howhigh : stacks*howhigh]){
		translate([0,0,i])
			springpart(scaleofcut=howhigh/i);
		translate([0,0,i]) rotate([0,0,45])
			springpart();
		translate([0,0,i+howhigh]) rotate([0,0,45])
			springpart();
		translate([0,0,i+howhigh]) rotate([0,0,0])
			springpart();
	}
}

sprang(stacks=1, howhigh=13);


