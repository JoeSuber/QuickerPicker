// collection of parts for the new picker idea

airflow = 57;
sleeveout = airflow+1;

// [fullOD, shaftD, thickness, turning_hubD]
hubbearing = [22,8,7,13];
travelbearing = [6,3,2.5,5];
travelwheel = 60;
travelpeg = travelwheel - travelbearing[1];

fat     = 0.3;  // add-on to make walls cut out enough space
hb      = 12.7 + fat; // height of bar cross-section
wthk    = 1.5 + fat;  // thickness of walls
flrthk  = 1.6 + fat;  // thickness of floor (that walls extend from)
inside  = 6.9 - fat;  // between walls, across floor (subtracting 2*.5*fat)
c_bar = [[0,0], [0,hb], [wthk, hb], [wthk, flrthk], [wthk+inside, flrthk], [wthk+inside, hb], [wthk+inside+wthk, hb], [wthk+inside+wthk, 0]];

//#shaft(travelbearing);
//#cbar(barH=100);
//#can_sleeve();
//translate([50,50,0])
//    for (i=[0:3:360]){
//        nutbolt(nut_position=20*i/360, channel_ang=i);
//    }
//bigwheel_part();
// bartest();
rotate([0,0,180]) translate([0, -56, +19])
    upndown();

//motorcut();
//cbar();
cbracket();


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
                shaftlen=20, 
                nut_position=17,
                nut_thick=2.33,  
                channel_len=30, 
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
            cylinder(r=hexhead/2+.1, h=nut_thick+.1, center=false, $fn=6);
        translate([cos(channel_ang)*channel_len, 
                    sin(channel_ang)*channel_len, 0])
            rotate([0,0,channel_ang])
                cylinder(r=hexhead/2+.2, h=nut_thick+.1, center=false, $fn=6);
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
    
module bigwheel_part(od=travelwheel, thk=4, hub=12, hubthk=4, holes=6, lever=5){
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

module bigwheel_cutout(od=travelwheel+3, thk=10){
    cylinder(r=od/2, h=thk, $fn=128);
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

module upndown(ht=travelwheel){
    difference(){
    cube([travelwheel, travelwheel/2, ht], center=true);
    // lift rail
    translate([0, travelwheel/2-hb, 0])
        cube([travelwheel+.1, hb+.1, c_bar[6][0]+.1], center=true);
    // side rails
    translate([-travelwheel/2 - hb/2 ,3, 0]) rotate([0,0,-90])
        cbar(barH=70);
    translate([travelwheel/2 + hb/2 ,3, 0]) rotate([0,0,90])
        cbar(barH=70);

    // cylinder space
    translate([0, -travelwheel/2, 0])
        cylinder(r = (sleeveout+.5)/2, h=ht+.1, $fn=196, center=true);
    // nuts
    translate([0,0,ht/4]) rotate([90,0,0])
        #nutbolt(channel_ang=90);
    translate([0,0,-ht/4]) rotate([90,0,0])
        #nutbolt(channel_ang=-90);
    }
}

module upndown_cutout(ht=travelwheel){
    translate([0,-4.5,0])
    cube([travelwheel+1, travelwheel/2+9.5, ht+2], center=true);
    // lift rail
    //translate([0, travelwheel/2+hb, 0])
    //    cube([travelwheel+.1, hb+.1, c_bar[6][0]+.1], center=true);
    // side rails
    translate([-travelwheel/2,-5, 0])
        cube([hb, c_bar[6][0], travelwheel], center=true);
    translate([travelwheel/2,-5, 0])
        cube([hb, c_bar[6][0], travelwheel], center=true);
    // cylinder of suckage
    translate([0, -travelwheel/2 -9.5, 0])
        cylinder(r = (sleeveout+2)/2, h=ht+2, $fn=196, center=true);

}

module motorcut(x=23,y=22,z=37,tab=[6,4,5],tabpos=7,curverad=5, shaftpos=[0,11,16], canheight=28){
    tiptop = canheight + z + tab[2] - curverad;
    // top-motorhousing
    translate([0,y/2, tiptop - canheight])
        cylinder(r=x/2, h=canheight, center=false, $fn=36);
    // gearbox housing
    translate([-(x-curverad*2)/2, 0, curverad+tab[2]])
        minkowski(){
            cube([x-curverad*2,y,z-curverad*2], center=false);
            rotate([90,0,0])
                cylinder(r=curverad, h=.1, center=false, $fn=64);
        }
    // tab thingy
    translate([0,tabpos+tab[1]/2, tab[2]/2]){
        cube(tab, center=true);
        // cuts hole for bolting tab
        rotate([90,0,0])
            cylinder(r=3.26/2, h=50, center=true, $fn=12);
    }
    // output hub stub and slide-in track
    translate(shaftpos)
        rotate([90,0,0])
            hull(){
            cylinder(r=9.14/2, h=y+4, center=true, $fn=18);
            translate([0,z-shaftpos[0], 0])
                cylinder(r=9.14/2, h=y+4, center=true, $fn=18);
            }
    // cuts shaft for holes that penetrate housing
    for (i=[1,-1]){
    translate([17.75/2 * i, 0, 36])
        rotate([90,0,0])
            cylinder(r=3.26/2, h=50, center=true, $fn=12);
    }
    // add on the driven wheel
    translate(shaftpos)
        rotate([90, 0,0]) translate([0,0,-y]){
            bigwheel_cutout();
            // and its connection hub
            translate([0,0,+3])
            hull(){
                cylinder(r=8, h=15, $fn=16, center=false);
                translate([0,z-shaftpos[0], 0])
                cylinder(r=8, h=15, $fn=16, center=false);
            }
        }
    // make a cut-out for the traveling part
    rotate([0,0,180]) translate(shaftpos) translate([0,-59,0])
    upndown_cutout();
}


        
module cbracket(z=travelwheel/2){
    difference(){
        translate([-travelwheel/2, 0, -11])
        minkowski(){
            cube([travelwheel, travelwheel*1.7, travelwheel-17], center=false);
            cylinder(r=8, h=1, $fn=16);
        }
    motorcut();
    translate([-travelwheel/2.5, 0, 5]) rotate([90,155,0])
    cbar(barH=30);
    translate([travelwheel/2.5, 0, 5]) rotate([90,-155,0])
    cbar(barH=30);
    }
}       
