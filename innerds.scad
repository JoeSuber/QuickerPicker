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

// ** the can traveler by itself ***
//rotate([0,0,180]) translate([0, -56, +25.9])
    //upndown();    

//motorcut();
//cbar();

// ** the main picker body ** 
//cbracket();

// ** the valve parts **
louvers();

plate_air_parts();
           

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

module ring(ID, OD, ht){
    difference(){
        cylinder(r=OD/2, h=ht, center=true, $fn=96);
        cylinder(r=ID/2, h=ht+.1, center=true, $fn=96);
    }
}

// for LMB8MM
module bearingcut(D=15.1/2, dring=14.41/2, drod=8.9/2, dziptie=[19,3.3],){
    rotate_extrude(center=true, convexity=10, $fn=36){
        polygon(points=[[0,-2], [D,0], 
                        [D,3.3], [dring,3.3], 
                        [dring,4.55], [D,4.55], 
                        [D,19.35], [dring,19.35], 
                        [dring,20.8], [D,20.8], 
                        [D, 24.01], [0,26.01]]);
    }
    // zip tie rings
    for (i=[(3.3+4.55)/2, (19.35+20.8)/2]){
        translate([0,0,i])
            ring(dziptie[0], dziptie[0]+dziptie[1], 5);
    }
    // rod upon which it travels
    translate([0,0,12])
        cylinder(r=drod, h=90, $fn=18, center=true);
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
    translate([-travelwheel/2+.5 ,3.25, 0]) rotate([0,0,-0])
        cube([hb+.5, c_bar[6][0]+1, travelwheel+.1], center=true);
    translate([travelwheel/2-.5 ,3.25, 0]) rotate([0,0,0])
        cube([hb+.5, c_bar[6][0]+1, travelwheel+.1], center=true);

    // cylinder space
    translate([0, -travelwheel/2, 0])
        cylinder(r = (sleeveout+.5)/2, h=ht+.1, $fn=196, center=true);
    // nuts
    translate([0,0,ht/4]) rotate([90,0,0])
        #nutbolt(channel_ang=90);
    translate([0,0,-ht/4]) rotate([90,0,0])
        #nutbolt(channel_ang=-90);
    }
    // underside printing supports for lift rail
    for (i=[0:5:travelwheel-1]){
        translate([i - travelwheel/2+2.5, travelwheel/2-hb*1.333, 0])
            cube([.5, hb*.37, c_bar[6][0]+.1], center=true);
    }
}

module upndown_cutout(ht=travelwheel){
    translate([0,-4.5,0])
    cube([travelwheel+1, travelwheel/2+9.5, ht+2], center=true);
    // lift rail
    //translate([0, travelwheel/2+hb, 0])
    //    cube([travelwheel+.1, hb+.1, c_bar[6][0]+.1], center=true);
    // side rails
    translate([-travelwheel/2+hb/2+.2,-5, 0]) rotate([0,0,90])
        cbar(barH=70);
    translate([travelwheel/2-hb/2-.2,-5, 0]) rotate([0,0,-90])
        cbar(barH=70);
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
    // tab thingy for motor attachment
    translate([0,tabpos+tab[1]/2, tab[2]/2]){
        cube(tab, center=true);
        // cuts hole for bolting tab
        rotate([90,0,0])
            cylinder(r=3.26/2, h=50, center=true, $fn=12);
    }
    // driven hub stub and slide-in track
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


// carve the big thing out of a block        
module cbracket(z=travelwheel/2, bs=1.5){
    difference(){
        translate([-travelwheel/2, 0, -4])
        minkowski(){
            cube([travelwheel, travelwheel*1.2, travelwheel-17], center=false);
            cylinder(r=8, h=1, $fn=16);
        }
    motorcut();
    translate([-travelwheel/2-bs, -bs, 4]) 
    bearingcut();
    translate([travelwheel/2+bs,-bs, 4])
    bearingcut();
    translate([z+2.5,z*2.5+.5,z*1.3]) rotate([0,0,0])
        #nutbolt(channel_ang=45);
    translate([-z-2.5,z*2.5+.5,z*1.3]) rotate([0,0,0])
        #nutbolt(channel_ang=135);
    translate([-z*.8, z*.5,z*1.23]) rotate([0,0,0])
        #nutbolt(channel_ang=180);
    translate([z*.8, z*.5,z*1.23]) rotate([0,0,0])
        #nutbolt(channel_ang=0);
    }
}
////-----------------------------////
//// *** air valve section  **** ////
//// ____________________________////

flapquant=4;
openingside=airflow/flapquant;
flapthick = 5;
buttonht = 4;
gap = 1.8; // between walls

flap = [[0,0], [flapthick,openingside], [flapthick,0], [0,-openingside]];

module one_love(scaler=1){
    // one flap with key holes  
    difference(){
        translate([-flapthick/2, 0, 0])
            linear_extrude(height=airflow){
                polygon(points=flap);
            }
    translate([0,0, airflow/2]) rotate([0,0,-10.1])
        scale([scaler,scaler,1]){
            cube([flapthick/2.8, openingside/1.5, airflow+.1], center=true);
        cylinder(r=1.6, h=airflow+.1, $fn=16, center=true);
        }
    }
}

module carabas(wheelrad=openingside/2){
    // its the place for louvers
    wheel = max(wheelrad, 3);
    difference(){
        cylinder(r1=wheel, r2=wheel-3, h=buttonht, $fn=196, center=true);
        scale([1.07,1.07,1]) 
            one_love(scaler=0.85);
        cylinder(r=1.6, h=4.1, $fn=16, center=true);
    }
}

module lever(lvrad= openingside/2 +1.5, lvthk=gap/2){
    difference(){
        hull(){
            cylinder(r=lvrad, h=lvthk, center=false, $fn=36);
            translate([0,25,0])
                cylinder(r=lvrad, h=lvthk, center=false, $fn=36);
        }
        hull(){
            translate([0,10,-0.05])
                cylinder(r=1.82, h=lvthk+0.1, center=false, $fn=36);
            translate([0,26,-0.05])
                cylinder(r=1.82, h=lvthk+0.1, center=false, $fn=36);
        }
    }
}

module louvers(){
    // the flaps- working well standing up
    for (i=[0:flapquant-2]){
        translate([i*openingside, 0, 0]) rotate([0,0,75])
        one_love();    
        translate([i*(openingside+3.2),-openingside*3 ,buttonht/2+gap/2]){
            carabas();
            //translate([0, 0, -buttonht/2 - gap/2])
            //    lever();
           mirror([0,1,0]) //{
            translate([0, openingside*1.2, 0]) 
                carabas();
           // translate([0, openingside*1.2, - buttonht/2- gap/2])
           //     lever();}
        }     
    } 
    //translate([airflow/2-openingside,openingside,airflow/2]) rotate([90,0,0])
     //   #circle(r=30, $fn=128, center=true);
}

module side_plate(sidethick=2, insider=1){
    // laying on its... side 
    difference(){
    translate([airflow - openingside*(flapquant-1), 0, buttonht/4])
        union(){
        cube([airflow, openingside*2 + 1, buttonht/2], center=true);
            for (i=[1,-1]){
                translate([i * (airflow/2+sidethick/2), 0,0]) rotate([0,-i*90,0])
                notcher();
            }
        }
        
        if (insider==1){   
            for (i=[0:flapquant-2]){   
                translate([i*openingside*1.06, 0, buttonht/2+0.05]) scale([1.09,1.09,1.09])
                    carabas();
            }
         }
    }
}

module notcher(cd=2.2, cz=6, clong=1){
    difference(){
        cube([cd, openingside*2, cz], center=true);
        translate([0,0,-clong/2-0.05])
            cube([cd+0.05, openingside*2-((cz-clong)*2), cz-clong], center=true);
    }
}
    
module end_plate(sidethick=2.2, ridge=1, cc=buttonht/2+0.2){
    xlen = airflow+sidethick*4+gap*2+ridge*2;
    translate([0,0,(sidethick+ridge)/2])
    difference(){
        cube([xlen, openingside*2 + 1, sidethick+ridge], center=true);
        translate([0,openingside/3, sidethick/2])
            cube([airflow+sidethick*4+gap*2, openingside/2-1, ridge+0.1], center=true);
        translate([0,-openingside/3, sidethick/2])
            cube([airflow+sidethick*4+gap*2, openingside/2-1, ridge+0.1], center=true);
        for (i=[1,-1], j=[cc, cc*3.5]){
        translate([i*(xlen/2-j),0, 0])
            scale([1.05,1.05,1.05])
                notcher(cd=cc, cz=6, clong=ridge);
        }
    }
}

module plate_air_parts(){
    translate([0,52,0]) end_plate();
    mirror([ 1, 0, 0 ]) { 
    translate([0,22,0]) end_plate(); }

    translate([airflow+2,-55,2]) rotate([180,0,90]) side_plate();
    mirror([ 1, 0, 0 ]) { 
    translate([-airflow-1,15,2]) rotate([180,0,90]) side_plate(); }

    translate([-25,-airflow+13,0]) rotate([0,0,90]){
        side_plate(insider=0);
        mirror([ 1, 0, 0 ]) {
        translate([65,airflow-100,0]) rotate([0,0,90])
            side_plate(insider=0); }
    }
}
