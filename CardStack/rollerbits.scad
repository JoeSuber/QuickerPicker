// corner parts & rollers to guide cards & belts

cornershape();

partht = 14;
curve = 10.9;

module cornershape(diam=curve, ht=partht, rod=0.254*25.4/2){
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
    }
}

module boltnut(rod=.254*25.4/2, ht=partht, nutrad=12.65/2, washrad=14/2, washthk=2, nutht=5.6){
    cylinder(r=rod, h=ht+0.1, $fn=24, center=false);
    translate([0,0,ht-nutht])
        cylinder(r=nutrad, h=partht, $fn=6, center=false);
}

module axles(rad=0.254*25.4/2, length=curve*1.41);