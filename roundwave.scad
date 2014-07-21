
// circular cam generator
// use cubes to make a smooth circular arangement of bumps

outsiderad = 35;
insiderad = 30;
pi = 3.141592653589793;
thickness = outsiderad - insiderad;
spot = insiderad + thickness / 2;
circumf = outsiderad * 2 * pi;
div = 4;					// wave 'peaks' or bumps around the circle
lift = 6;  					// peak-to-trough height of bumps
detail = 720;				// how many divisions in a bump-block (aka div), i.e. resolution				
ranger = 360*div;				// how many degrees of a circle to represent
part_circle = ranger/360 * circumf;
bit = part_circle / ranger;
deg_in_detail = bit/part_circle * 360;



module hump (div=div, ranger=ranger, lift=lift, detail=detail, thickness=thickness, base=1.5){
	for (i=[1 : (1/detail)*ranger : ranger]){
		translate([cos( i/div) * spot, sin( i/div) * spot, (lift + lift*sin(i))/2]) 
		rotate([0,0, i/div])
			scale([1, 1, 1])
			cube([thickness, (1/detail) * part_circle, base+ (lift + lift*sin(i))], center=true);
	}
}

module roller (div=div, ranger=ranger, lift=lift, detail=detail, thickness=thickness, sc=[1,1,1], base=1.5){
			scale(sc)
				hump(div=div, ranger=ranger, lift=lift, detail=detail, thickness=thickness, base=1.5);
}

roller(sc=[1,1,.5]);