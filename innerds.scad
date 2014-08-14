// collection of parts for the new picker idea

airflow = 57;
sleeveout = airflow+1;

// [fullOD, shaftD, thickness, turning_hubD]
hubbearing = [22,8,7,13];
travelbearing = [6,3,2.5,5];
travelwheel = 50;
travelpeg = travelwheel - travelbearing[1];

fat     = 0.3;  // add-on to make walls cut out enough space
hb      = 12.7 + fat; // height of bar cross-section
wthk    = 1.5 + fat;  // thickness of walls
flrthk  = 1.6 + fat;  // thickness of floor (that walls extend from)
inside  = 6.9 - fat;  // between walls, across floor (subtracting 2*.5*fat)
c_bar = [[0,0], [0,hb], [wthk, hb], [wthk, flrthk], [wthk+inside, flrthk], [wthk+inside, hb], [wthk+inside+wthk, hb], [wthk+inside+wthk, 0]];

travelwheel = 60;

//#shaft(travelbearing);
//#cbar(barH=100);
//#can_sleeve();
//translate([50,50,0])
//    for (i=[0:3:360]){
//        nutbolt(nut_position=20*i/360, channel_ang=i);
//    }
//bigwheel_part();

bartest();

// for cutting out shaft and hub-turning space
module shaft(bearing, xtraH=0, hubclearance=0.5){
    height=bearing[2] + xtraH;
    translate([0,0,-height/2-hubclearance/2])
        cylinder(r=bearing[3]/2, h=hubclearance, center=true, $fn=28);
    translate([0,0,0])
        cylinder(r=bearing[1]/2, h=height, center=true, $fn=24);
    translate([0,0,height/2+hubclearance/2])
        cylinder(r=bearing[3]/2, h=hubclearance, center=true, $fn=28);
    echo("shaft of bearing = ", bearing, "is top-to-bottom = ", hubclearance*2 + height);
} 

// alluminum c-channel, positive or negative
module cbar(outline=c_bar, barH=50){
    midbar = outline[7][0] / 2;
    echo("midbar read as: ",midbar);
    translate([-midbar,0,0])
    linear_extrude(center=true, height=barH, convexity=10, slices=2)
        polygon(points=outline);
}

// intended as positive model, could add scale or thickness
module can_sleeve (emptyness=airflow, thickness=sleeveout-airflow-0.2, sleeveH=25){
    translate([0,0,-sleeveH/2])
        rotate_extrude($fn=196)
            translate([(emptyness+thickness) / 2, 0, 0])
                polygon(points=[[0,0], [0,sleeveH], [thickness,sleeveH], [thickness,0]]);
}

// negative model with channel for captured nut insertion
module nutbolt(hexhead=6.65, 
                shaftD=3.1, 
                shaftlen=28, 
                nut_position=9,
                nut_thick=2.33,  
                channel_len=0, 
                channel_ang=0,){
    color( .5, .9, .9 )
    translate([0,0,-shaftlen/2]){  //center it by shaftlen
        //shaft
        cylinder(r=shaftD/2, h=shaftlen, center=false, $fn=18);
        //head
        #translate([0,0,shaftlen-hexhead/2])
        cylinder(r=hexhead/2, h=hexhead/2, center=false, $fn=6);
        //nut + channel
        translate([0,0,shaftlen-nut_position])
        hull(){
        rotate([0,0,channel_ang])
            cylinder(r=hexhead/2, h=nut_thick, center=false, $fn=6);
        translate([cos(channel_ang)*channel_len, 
                    sin(channel_ang)*channel_len, 0])
            rotate([0,0,channel_ang])
                cylinder(r=hexhead/2, h=nut_thick, center=false, $fn=6);
        }
    }
}

module motorhub(flat_to_flat=4.76, diameter=7.4, height=5.57, baseD=9, baseH=1.0){
    cutrad = (diameter - flat_to_flat)/2;
    cutcenter = flat_to_flat/2 + cutrad;
    cylinder(r=baseD/2, h=baseH+0.1, center=false, $fn=36);
    cylinder(r=0.8, h=baseH+5*height+.1, center=true, $fn=6);
    translate([0,0,baseH])
        difference(){
            cylinder(r=diameter/2, h=height+baseH, center=false, $fn=24);
            for (i=[cutcenter+0.05, -cutcenter-0.05]){
                translate([0,i,(height+baseH)/2])
                    cube([diameter+0.1, cutrad+0.1, height+.1], center=true);
            }

        }
}
    
module bigwheel_part(od=travelwheel, thk=4, hub=12, hubthk=4, show=true, holes=6, lever=5){
    overall_thk = thk+hubthk;
    echo("overall bigwheel thickness is : ", overall_thk);
    difference(){
        union(){
            cylinder(r=od/2, h=thk, $fn=196);
            translate([0,0,4])
            cylinder(r=hub/2, h=hubthk, $fn=64);
        }
        translate([0,0,overall_thk+0.05]) rotate([180,0,0])
            motorhub();
        for (i=[0 : 360/holes : 360-(360/holes)*.5]){
            translate([od/3.14*cos(i), od/3.14*sin(i), hubthk/2])
                cylinder(r=od*.5/(holes-1), h=hubthk+.1, center=true, $fn=42);
        }
        translate([0,od/2-lever,-9]) rotate([0,0,0])
            nutbolt();
        translate([0,-od/2+lever,-9]) rotate([0,0,0])
            nutbolt();
    }
}


module bartest(ht=10){
    difference(){
    minkowski(){
        cube([20,20,10], center=true);
        cylinder(r=4, h=.1, center=true, $fn=24);
    }
    translate([-7,-9,0])
        #cbar(barH=30);
    translate([17,0,0]) rotate([0,0,90])
        #cbar(barH=30);
    translate([0,10.5,0]) rotate([90,0,0])
        #shaft(hubbearing);
    }
}
        
