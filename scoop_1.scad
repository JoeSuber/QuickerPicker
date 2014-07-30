cardthick= 41.18/134;
echo("one card thickness (mm) =", cardthick);
cardsize=	[88.05, 63.19, cardthick];
cardcorner= 5;
scoopheight=29;
cardcenter=	cardsize/2;
cardedge=	[cardsize[0]-cardcorner, cardsize[1]-cardcorner];
echo("cardedge =",cardedge);

module singlecard(){
	minkowski(){
		square(cardedge, center=true);
		circle(cardcorner/2, $fn=36);
	}
}

module squaremm(size, border=3, ht=scoopheight){
	difference(){
		cube([size, size*cardsize[1]/cardsize[0], ht], center=true);
		cube([size-border, size*cardsize[1]/cardsize[0]-border, ht+.1], center=true);
		echo("measurement frame outside is = ",[size,size]);
		echo("thickness of walls of frame: ", border/2); 
		echo("measurement frame inside is = ",[size-border, size-border]);
		echo("height is = ", ht);
	}
}

module tray(floorthk=0, scaledif=.05, sideslope=1.4, scooph=scoopheight){
	translate([0,0,0])
	difference(){
		union(){
			linear_extrude (height=scooph, center=true, convexity=10, twist=0, scale=sideslope){
				scale([1+scaledif,1+scaledif,1])
					singlecard();
			}
			for (i=[-cardedge[0]/2, cardedge[0]/2]){
				translate([i,0,0])
					cube([scooph*(sideslope+scaledif) - scooph*sideslope, 
						sideslope*cardsize[1]*(1+scaledif),
						scooph], center=true);
			}
		}
		translate([0,0,floorthk])
			linear_extrude (height=scooph*(1+scaledif)+.01, 
							center=true, 
							convexity=10,
							twist=0, scale=sideslope){
				scale([1,1,1])
					singlecard();
			}
		//singlecard();	
	}
}


translate([0,0,0]) minkowski(){ squaremm(cardsize[0]*1.4+3); sphere(r=2, h=3, $fn=36, center=true);}
tray();

		
	
