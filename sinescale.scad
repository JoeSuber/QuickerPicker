// scale things by wavey functions

// break range into parts
parts = 20;
// each part will climb how many z-axis units
units_per_part = 1;
// from zero, how many degrees to be covered?
degrees = 420;
deg_per_part = degrees/parts;
// starting x at z=0
sizex=7;
sizey=4;
unit_part = units_per_part*parts;
newx = max(.01, sizex);
pi = 3.141592653589793;

module solidwave (x){
	for (i=[x:deg_per_part:x+degrees]){
			translate([0,0,unit_part*i/degrees - unit_part*0.5])  // - unit_part*0.5 to center it
				cylinder(r1=newx + newx*sin(i), r2=newx + newx*sin(i+deg_per_part), h=units_per_part, center=true, $fn=48);
	}
}

module waveline (q=90, perimeter=pi*newx*2){
	scaler=1 + newx / (newx+sizey);
	sizeup = sizey * scaler * parts;
	for (i=[0:deg_per_part:degrees]){

			translate([newx*cos(i)/2, newx*sin(i)/2,   i/degrees*unit_part]) //  i/degrees*unit_part
				rotate([(cos(i)*degrees/parts-33), (degrees/parts*sin(i)), i])
					
				//scale([units_per_part+units_per_part*sin(i),units_per_part+units_per_part*cos(i),1])
					linear_extrude(height=sizey, center=true, scale=[1,.8]){
						square([perimeter/sizeup*sizey,perimeter/sizeup*sizey,], center=true);
					}
	}
}

translate([0,0,12])
rotate([90,0,0])
	linear_extrude(height=2, center=true, scale=[1,1]){

		projection(cut = false) 	rotate([0,90,0]) solidwave(22);
	}
//projection(cut = false)			rotate([0,90,0]) waveline();


