// corner parts & rollers to guide cards & belts

cornershape();
translate([-15, -15, 0])
    cornershape();
translate([-37,0,0])
    roller();
    
translate([32,0,0])
    roller();
    
partht = 14;
curve = 10.9;
rodr = 0.254*25.4/2;


module cornershape(diam=curve, ht=partht, rod=rodr){
    difference(){
        union(){
            cylinder(r=diam/2, h=ht, $fn=64, center=false);
            translate([0,diam/1.41, ht/2])
                cube([diam,diam*1.41,ht], center=true);
            translate([diam/1.41, 0, ht/2])
                cube([diam*1.41, diam, ht], center=true);
        }
    translate([0,0,-.05])
        #boltnut();
        translate([diam/1.2, diam/1.2, rod*2]) rotate([180,180,0])
            #axles();
    }
}

module boltnut(rod=rodr, ht=partht, nutrad=12.65/2, washrad=14/2, washthk=2, nutht=5.6){
    cylinder(r=rod, h=ht+0.1, $fn=24, center=false);
    translate([0,0,ht-nutht])
        cylinder(r=nutrad, h=partht, $fn=6, center=false);
}

module axles(rad=rodr, length=curve*3){
    for (i=[0,90]){
        rotate([0,90,i])
            cylinder(r=rad, h=length+.5, $fn=24, center=false);
    }
}

module roller(ht=63.5+1.6,  rad=rodr*3+curve*1.41 - curve*1.2, spinhole=rodr){
    difference(){
        union(){
            cylinder(r1=rad+0.8, r2=rad, h=.8, $fn=96);
            cylinder(r=rad, h=ht, $fn=96);
            translate([0,0,ht-.8])
                cylinder(r1=rad, r2=rad+0.8, h=.8, $fn=72);
        }
    translate([0,0,ht/4+.8])
        #cylinder(r1=spinhole+.65, r2=rad-1, h=(ht-3.6)*.51, $fn=24, center=true);
    translate([0,0,ht*0.75-.8])
        #cylinder(r1=rad-1, r2=spinhole+.65, h=(ht-3.6)*.51, $fn=24, center=true);
    translate([0,0,-.05])
        #cylinder(r=spinhole, h=ht+0.1, $fn=64);    
    }
}