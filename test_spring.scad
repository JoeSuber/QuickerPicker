// test parts for kinematic practicality

use <innerds.scad>;

springlen = 30;

for (i=[-1,0,1]){
    translate([0,i*(10+1),5/2])
        spring();
}

translate([0,0,17]){
    //%contact_ring(fat=1);
    nest_ring();
    translate([65,4,-2])
        contact_ring(fat=1);
}
//small_switch();

module spring(sl=springlen, sh=10, stp=2, tab=6){
    difference(){
        union(){
            // spring body    
            cube([sl, sh, sh/2], center=true);
            // tabs for insertions
            for (i=[-sl/2-tab/2+1, sl/2+tab/2-1]){
                translate([i, 0, -sh/4+0.5])
                    minkowski(){
                        cube([tab-2, sh-2, 1-0.1], center=true);
                        cylinder(r=1, h=0.1, center=true, $fn=12);
                    }
            }
        }
        // diff out gaps
        for (i=[stp+1:stp*2:sl-stp/2], j=[-stp/2,stp/2]){
            translate([i-sl/2, stp/2, 0])
                cube([stp/2, sh+0.05,sh/2+0.1], center=true);
            translate([i-sl/2-stp, -stp/2, 0])
                cube([stp/2, sh+0.05,sh/2+0.1], center=true);
        }
        // holes in tabs
        for (i=[-sl/2-tab/2, sl/2+tab/2]){
            translate([i, 0, -sh/2+0.5])
                cylinder(r=1.7, h=sh, $fn=12, center=true);
        }
    }
}

module springcut(sl=springlen, sh=10, stp=2, tab=6){
    scale([1.0, 1.05, 1.05]){
        cube([sl, sh, sh/2], center=true);
        translate([0,0,-sh/4+0.5])
            cube([sl+tab*2, sh, 1], center=true);
        for (i=[-sl/2-tab/2, sl/2+tab/2]){
            translate([i, 0, -sh/4+0.5])
                cylinder(r=1.7, h=sh+1, $fn=12, center=true);
        }
    }
}

module alutube(OD=5.56, ID=4.7, ht=20){
    wedge=(OD-ID)/2;
    difference(){
        union(){
        translate([0,0,ht/2-wedge/2])
            cylinder(r1=OD/2, r2=ID/2, h=wedge+.05, center=true, $fn=round(OD*6));
        mirror([0,0,1]) translate([0,0,ht/2-wedge/2])
            cylinder(r1=OD/2, r2=OD/2, h=wedge, center=true, $fn=round(OD*6));
        cylinder(r=OD/2, h=(ht-wedge*2), center=true, $fn=round(OD*6));
        }
        cylinder(r=ID/2, h=ht+0.1, center=true, $fn=round(OD*6));
    }
}

module contact_ring(OD=58, wall=2, base=10, crown=5, ht=30, fat=1, sx=.3){
    springspot = 11;
    midwall=(OD*fat + (OD-wall*2*fat))/4 -.5;
    difference(){
        alutube(OD=OD*fat, ID=OD-wall*2*fat, ht=ht);
        for (i=[120,240,360]){
            translate([midwall*cos(i), midwall*sin(i), springspot]) rotate([i-180, -90,0]) 
                springcut();
        }
        for (i=[60,180,300]){
            translate([(midwall-sx)*cos(i), (midwall-sx)*sin(i), 14]) rotate([180, 0, i-90]) 
                small_switch();
        }
    }
    //redraw the spring-cuts as positives if needed for cut-out duty
    if (fat > 1){ 
        for (i=[120,240,360]){
            translate([midwall*cos(i), midwall*sin(i), springspot-4]) rotate([i-180, -90,0]) 
                scale([1, fat, fat])
                springcut();
        }
        for (i=[60,180,300]){
            translate([(midwall-sx)*cos(i), (midwall-sx)*sin(i), 14]) rotate([180, 0, i-90]) 
                small_switch();
        }
    }
}

module nest_ring(OD=64.6, wall=4.6, fat=1.00, ht=34){
    midwall=(OD*fat + (OD-wall*2*fat))/4;
    difference(){
        alutube(OD=OD, ID=OD-wall*2, ht=ht);
        translate([0,0,-13]) 
                contact_ring(fat=1.06);
    }
}
    
