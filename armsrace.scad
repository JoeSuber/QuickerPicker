// solenoid actuator arms

// idea: use m3 screws & nuts as fulcrums of flat levers that
// magnify the short throw of the solenoids to do useful stuff

longside = 60;
shortside = 8.67;
thickness=7;
solenoid_travel = 3.6;

echo("long-side vertical change is: ", solenoid_travel*longside/shortside);

//flatarm();
realarm();
translate([-20,0,10]) rotate([180,0,0])
    mmrodhold();
translate([-10,10,10]) rotate([180,0,0])
    mmrodhold();
translate([20,-20,0]){
translate([-20,0,10]) rotate([180,0,0])
    mmrodhold();
translate([-10,10,10]) rotate([180,0,0])
    mmrodhold();
}
//translate([0,20,1.5])
//difference(){
 //   cube([25,25,21], center=true);
 //   cube([12.5,12.1,20], center=true);
//}

module mmrodhold(rod=4, ht=10, capture=6.67, bolt=3.3, capthick=2.3){
    difference(){
        cylinder(r=rod*1.711, h=ht, $fn=6);
        cylinder(r=rod/2+0.25, h=ht/2, $fn=36);
        hull(){
            translate([rod/2+0.5+capthick/2, 0, capture/2]) rotate([0,90,0])
                cylinder(r=capture/2, h=capthick, $fn=6, center=true);
            translate([rod/2+0.5+capthick/2, 0, 0]) rotate([0,90,0])
                cylinder(r=capture/2, h=capthick, $fn=6, center=true);
        }
            translate([rod/2+capthick/2, 0, capture/2]) rotate([0,90,0])
                #cylinder(r=bolt/2, h=rod*1.9, $fn=8, center=true);
    }
}
        

module flatarm(thk=thickness, nut=6.67, bolt=3.25, abc=longside+shortside){
    difference(){
        union(){    
            square([abc,thk]);
            for (i=[0,shortside,longside,abc]){
                translate([i,thk/2,0])
                    circle(r=nut/2 + 2, $fn=48);
            }
        }
        for (i=[0,shortside,longside,abc]){
            translate([i,thk/2,0])
		if ((i>0) && (i !=abc)){
			circle(r=nut/2, $fn=6);
		}
		else{
			circle(r=bolt/2, $fn=12);
		}
        }
    }
}

module nutring(surround=6.67/2 + 2, hexhole=6.67/2, roundhole=0, ht=1){
    difference(){
        cylinder(r=surround, h=ht, $fn=36, center=true);
        if(hexhole>0){
            cylinder(r=hexhole, h=ht+0.1, $fn=6, center=true);
        }
        else if(roundhole > 0){
            cylinder(r=roundhole, h=ht+0.1, $fn=14, center=true);
        }
        else{
            echo("HEY! hexhole and roundhole were not > 0");  
        }
    }
}
    
module realarm(ht=1.5, layer=1 ){
	linear_extrude(convexity=10, height=ht){
		flatarm();
	}
    for(i=[0,shortside, longside, shortside+longside], j=[0,1]){ 
        translate([i,thickness/2,ht+layer/2+j*layer]){
            if (j==0){
                nutring(hexhole=0, roundhole=1.65);
            }
            if ((j==1) && ((i==0) || (i==(shortside+longside)))){
                nutring(hexhole=6.67/2, roundhole=0);
            }
            else if(j==1){
                #nutring(hexhole=0, roundhole=1.65);
            }
        }
    }
}
