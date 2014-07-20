
incoming=62.47;
rim=3;
bigrad=incoming/2 - rim;


module coni(dir=1, incoming=62.47, rim=3, ang_of_attack=90){
	bigrad=incoming/2 - rim;
	projection() translate([0,dir*bigrad/2+dir/2,bigrad]) rotate([ang_of_attack*dir,0,0]) 
		cylinder(r1=bigrad-rim, r2=2, h=bigrad, center=true, $fn=128);
	}

module pieslice(incoming=62.47, rimin=5, angin=76){
	for(i=[1,-1]){
		coni(dir=i, incoming=62.47, rim=rimin, ang_of_attack=angin);
	}
}

pieslice();



