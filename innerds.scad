// collection of parts for the new picker idea
// NOT using the air-valve/ plate_air_parts.
//

airflow = 57;
sleeveout = airflow+1;

// [fullOD, shaftD, thickness, turning_hubD]
hubbearing = [22,8,7,13];
travelbearing = [6,3,2.5,5];
travelwheel = 50;
travelpeg = travelwheel - travelbearing[1];

// * c-bar cut-out / model
fat     = 0.6;  // add-on to make walls cut out enough space
hb      = 12.7 + fat; // height of bar cross-section
wthk    = 1.5 + fat;  // thickness of walls
flrthk  = 1.6 + fat;  // thickness of floor (that walls extend from)
inside  = 9.97 - fat;  // between walls, across floor (subtracting 2*.5*fat)
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
//cam(ht=5);
//translate([36,30,0]) rotate([0,0,90])
 //   end_plate_motor();
//rackpush();

// ** the main picker body ** 
translate([0,0,4])
    cbracket();
//translate([60,0,0])
//    bigwheel_part();
translate([70,0,0])
    lifts();
// ** the valve parts **
//louvers();

//plate_air_parts();
// translate([36,30,0]) 
//    wankel();         

use <twofan.scad>;
use <gearlift.scad>;

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
module nutbolt( roundhead=5.6,
				hexhead=6.65, 
                shaftD=3.25, 
                shaftlen=20, 
                nut_position=17,
                nut_thick=2.4,  
                channel_len=30, 
                channel_ang=0,){
    color( .5, .9, .9 )
    translate([0,0,-shaftlen/2]){  //center it by shaftlen
        //shaft
        cylinder(r=shaftD/2, h=shaftlen, center=false, $fn=18);
        //head
        translate([0,0,shaftlen-hexhead/2])
        cylinder(r=roundhead/2, h=hexhead/2, center=false, $fn=12);
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

module motorhub(flat_to_flat=4.76, diameter=7.4, height=6, baseD=9, baseH=1.0){
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
    
module bigwheel_part(od=travelwheel, thk=3.5, hub=12, hubthk=4, holes=6, lever=5){
    overall_thk = thk+hubthk;
    echo("overall bigwheel thickness is : ", overall_thk);
    difference(){
        union(){
            cylinder(r=od/2, h=thk, $fn=196);
            translate([0,0,thk])
            cylinder(r=hub/2, h=hubthk, $fn=64);
        }
        translate([0,0,0]) rotate([0,0,0]) scale([1.2,1.2,1.2])
            #small_shaft();
           // motorhub();
        for (i=[0 : 360/holes : 360-(360/holes)*0.5]){
            translate([od/3.14*cos(i), od/3.14*sin(i), hubthk/2])
                cylinder(r=od*.5/(holes-1), h=hubthk+.1, center=true, $fn=42);
        }
        translate([0,od/2-lever,0]) rotate([180,0,0])
            nutbolt(channel_len=0, nut_position=14);
        translate([0,-od/2+lever,0]) rotate([180,0,0])
            nutbolt(channel_len=0, nut_position=14);
        translate([7,0,3.2]) rotate([90,0,90])
            #nutbolt(channel_len=6, nut_position=11.7, channel_ang=90, shaftlen=12);
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

module bigwheel_cutout(od=travelwheel+3, thk=15){
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
    translate([0,0,0])
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

module motorcut(x=23,y=22,z=37,tab=[6.2,5,7],tabpos=7.1,curverad=5, shaftpos=[0,11,20.5], canheight=28){
    tiptop = canheight + z + tab[2] - curverad;
    /***** switching to small gearmotors in tandem ****
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
    ****** END of bigger plastic gearmotor */

    // add on the driven wheel
    translate(shaftpos)
        rotate([90, 0,0]) translate([0,0,-y]){
            bigwheel_cutout();
            // and its connection hub
            translate([0,0,+1])
            hull(){
                cylinder(r=13, h=17, $fn=36, center=false);
                translate([0,z-shaftpos[0], 0])
                cylinder(r=20, h=17, $fn=36, center=false);
            }
            // and the little motor that could
            translate([0,0,45.2]) rotate([180,0,0]) scale([1.07,1.07,1.07]){
                motor();
                // with a bridge
                translate([0,0,6]) rotate([0,0,0]) scale([.57,2,1])
                    cylinder(r=5/.65, h= 25, $fn=36);
                // and a sensor-hole
                for (i=[0,1]){
                    mirror([i,0,0])
                    translate([14,8,3]) rotate([0,0,-45]) scale([1.15,1.15,7])
                        #sensor();
                }
            }
        translate([0,-6.5,1]) cbar();
            for (i=[0,1]){
                mirror([i,0,0])
                translate([23.3,25.5,20]) rotate([180,0,0]) #cbar();
            }
        }
    // make a cut-out for the traveling part
    rotate([0,0,180]) translate(shaftpos) translate([0,-59,0])
    upndown_cutout();
}


       
module cbracket(z=travelwheel/2, bs=1.5){
// carves the big thing out of a block 
    difference(){
        translate([-(travelwheel-6)/2, 0, -4])
        minkowski(){
            cube([travelwheel-6, travelwheel/2-1.5, travelwheel-1], center=false);
            cylinder(r=8, h=1, $fn=36);
        }
    motorcut();

    translate([z+2.5,z*2.5+.5,z*1.3]) rotate([0,0,0])
        nutbolt(channel_ang=45);
    translate([-z-2.5,z*2.5+.5,z*1.3]) rotate([0,0,0])
        nutbolt(channel_ang=135);

    translate([-z*.92, z*.5,z*1.4]) rotate([0,0,0])
        nutbolt(channel_ang=180);
    translate([z*.92, z*.5,z*1.4]) rotate([0,0,0])
        nutbolt(channel_ang=0);

    translate([-z * 0.92, z*.5,0]) rotate([180,90,0])
        nutbolt(channel_ang=0);
    translate([z * 0.92, z*.5,0]) rotate([180,-90,0])
        nutbolt(channel_ang=180);
    translate([-z * 0.8, 0,1]) rotate([90,0,0])
        #nutbolt(channel_ang=180);
    translate([z * 0.8, 0,1]) rotate([90,0,0])
        nutbolt(channel_ang=0);
    translate([-z * 0.8, -2, 20]) rotate([90,0,0])
        nutbolt(channel_ang=180);
    translate([z * 0.8, -2, 20]) rotate([90,0,0])
        nutbolt(channel_ang=0);
    translate([-z * 0.8, 5, 40]) rotate([0,0,0])
        nutbolt(channel_ang=180);
    translate([z * 0.8, 5, 40]) rotate([0,0,0])
        nutbolt(channel_ang=0);
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

module pie(arc=90, center=90, rad=11, height=3){
    rotate([0,0,center-arc/2])
     difference(){
        children();
        translate([0,-rad, 0])
            cube([rad*2,rad*2,rad*2], center=true);
        rotate([0,0,arc])
        translate([0,rad, 0])
            cube([rad*2,rad*2,rad*2], center=true);
    }
}

module degreed(sect=90, mks=60, size=15){
    for (i=[0:sect/mks:sect-1]){
        translate([cos(i)*size, sin(i)*size, 3])
            color([.9, i/sect*2+.5,0,1])
                cylinder(r=sect/mks/4, h=6, $fn=12, center=true);
    }
}

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
        cylinder(r=1.65, h=airflow+.1, $fn=16, center=true);
        }
    }
}

module carabas(wheelrad=openingside/2, leverscale=1){
    // its the place for louvers
    wheel = max(wheelrad, 3);
    translate([0,0,-gap/2- buttonht/2])
        cylinder(r=wheel+.1, h= gap/2, $fn=24, center=false);
    difference(){
        cylinder(r1=wheel, r2=wheel-3, h=buttonht, $fn=196, center=true);
        scale([1.07,1.07,1]) 
            one_love(scaler=0.85);
        cylinder(r=1.7, h=4.1, $fn=16, center=true);
    }
    translate([-wheel+(openingside/2+1.5)/4, 0, -buttonht/2 - gap/2])
        lever(lvrad= openingside/2 +1.5, lvthk=gap/2, lvscale=leverscale);
}

module lever(lvrad=openingside/2 + 1.5, lvthk=gap/2, lvscale=1){
    difference(){
        union(){
            hull(){
                cylinder(r=(lvrad + 1.5)/4, h=lvthk, center=false, $fn=16);
                translate([0,9/lvscale,0])
                    cylinder(r=(lvrad + 1.5)/4, h=lvthk, center=false, $fn=16);
            }
            translate([0,9/lvscale,0])
                cylinder(r=2, h=lvthk*2 + 0.25, center=false, $fn=16);
        }
        if (lvscale < 1.001){
            translate([0,9/lvscale,-0.05])
                cylinder(r=1.65, h=lvthk*2 + 0.25 + 0.1, center=false, $fn=6);
        }
    }
}

module louvers(){
    // the flaps- working well standing up
    for (i=[0:flapquant-2]){
        translate([i*openingside, 0, 0]) rotate([0,0,75])
        one_love();    
        translate([i*(openingside+.5)+5,-openingside*2.8 ,buttonht/2+gap/2]){
            carabas();
            //translate([0, 0, -buttonht/2 - gap/2])
            //    lever();
           mirror([0,1,0]) //{
            translate([-openingside*0.4, -openingside*1.8, 0]) 
                carabas();
           // translate([0, openingside*1.2, - buttonht/2- gap/2])
           //     lever();}
        }     
    } 
    //translate([airflow/2-openingside,openingside,airflow/2]) rotate([90,0,0])
     //   #circle(r=30, $fn=128, center=true);
}

module side_plate(sidethick=2, insider=1, scalecut=1.06){
    // laying on its... side 
    difference(){
    translate([airflow - openingside*(flapquant-1), 0, buttonht/4])
        union(){
        cube([airflow, openingside*2 + 8, buttonht/2], center=true);
            for (i=[1,-1]){
                translate([i * (airflow/2+sidethick/2), 0,0]) rotate([0,-i*90,0])
                notcher();
            }
        }
        
        for (i=[0:flapquant-2]){
            translate([i*openingside*1.06, 0, (buttonht/2+0.05)*(1-insider)])
                pie(arc=111, center=95, rad=13.6, height=4){
                   rotate_extrude(convexity=10, $fn=36){
                   translate([11/scalecut, 0, 0])
                      square([4.2,2.5], center=true);
                   }
                }
        }

        if (insider==1){
            echo("flapquant =",flapquant);   
            for (i=[0:flapquant-2]){ 
                echo("i*openingside = ",i*openingside);  
                translate([i*openingside*1.06, 0, buttonht/2+0.05]){ 
                    scale([scalecut,scalecut,scalecut])
                       rotate([0,0,-81])
                       carabas(leverscale=scalecut);

                }
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
    xlen = airflow+sidethick*4+gap*4+ridge*2;
    translate([0,0,(sidethick+ridge)/2])
    difference(){
        cube([xlen, openingside*2 + 8, sidethick+ridge], center=true);
        translate([0,openingside/3, sidethick/2])
            cube([airflow+sidethick*4+gap*2, openingside/2-1, ridge+0.1], center=true);
        translate([0,-openingside/3, sidethick/2])
            cube([airflow+sidethick*4+gap*2, openingside/2-1, ridge+0.1], center=true);
        for (i=[1,-1], j=[cc, cc*3.5]){
        translate([i*(xlen/2-j),0, 0])
            scale([1.05,1.05,1.05])
                notcher(cd=cc, cz=6.75, clong=ridge);
        }
    }
}

module motorbox(){
    cube([12,10,25.4], center=true);
    cylinder(r=2, h=26.5, $fn=14, center=true);
    translate([0,0,(33.3+26.5)/4])
        cylinder(r=1.7, h=33.3-26.5, $fn=14, center=true);
}

module wankel(travel1=openingside, spread=15.11/2, rad=18.55, thk=5, maxw=18.77, rot_rad=15.11,  ht=10, shaft=[2.89, 2.45], shaftscale=1.24){
    unit=travel1/3;
    translate([(rot_rad - maxw)/4,0,0]) scale([1.06,1.06,1])
    difference(){    
        //intersection_for (i=[60, 120, 180, 240, 300, 360]){
           // translate([spread*cos(i), spread*sin(i), thk/2])
            translate([0,0, thk/2])
                cylinder(r=rad/2, h=thk, $fn=64, center=true);
       // }
        //#cylinder(r=rad-spread, h=thk+1, center=true, $fn=24);
        // dshaft

        translate([unit+.25*unit, 0,0]) scale([shaftscale, shaftscale, shaftscale]) rotate([0,0,-90])
            difference(){
                cylinder(r=shaft[0]/2, h=10.1, $fn=16, center=false);
                translate([0, (shaft[0]+shaft[1])/2 - shaft[0]/2, (ht-0.1)/2])
                    cube([shaft[0], shaft[0] - shaft[1], ht+0.1], center=true);
            echo("shaftscale for printing is:",shaftscale*shaft[0]);
        }
    }
    //#cylinder(r=.5, h=thk+5, center=true, $fn=6);
    //#cube([maxw,maxw,1], center=true);
   // #cube([rot_rad,rot_rad,2], center=true);
}
    
module cam(travel1=openingside, platethick=gap, brdr=5, shaft=[2.89, 2.45], ht=10, shaftscale=1.3, extracut=0){
    // 'wheelrad' is coincidentally the desired travel-range
    // cam travel should be 3/4 of tangent circles with 'unit' radii
    unit = travel1/3;
    rotate([0,0,90]) translate([0, 0, 0])
    difference(){
        union(){
            hull(){
                translate([unit, 0, 0])
                    cylinder(r=unit, h=ht, $fn=48, center=false);
                translate([-unit, 0, 0])
                    cylinder(r=unit, h=ht, $fn=48, center=false);
            }

            translate([unit+.2*unit, 0, ht]) scale([1.1, unit/(unit+3), 1])
                cylinder(r=unit+3, h=1.5, $fn=48, center=false);
            translate([(unit+.2*unit)*2.1, 0,ht-1.5])
                cube([3,.5,3], center=true);
            }
    // dshaft
    translate([unit+.2*unit, 0,0]) scale([shaftscale, shaftscale, shaftscale])
        difference(){
            cylinder(r=shaft[0]/2, h=10.1, $fn=16, center=false);
            translate([0, (shaft[0]+shaft[1])/2 - shaft[0]/2, (ht-0.1)/2])
                cube([shaft[0], shaft[0] - shaft[1], ht+0.1], center=true);
        echo("shaftscale for printing is:",shaftscale*shaft[0]);
        }
    }

    // cam plate
    rad = unit*2;
    clearance = 0.2;
    rotate([0,0,90]) 
        difference(){
            translate([0,0,platethick])
                minkowski(){
                    cylinder(r=brdr/2+clearance, h=.01, $fn=18);
                    cube([rad*2,rad*3, platethick*2], center=true);
                }
            translate([0, 0, -0.1]){
                echo("camhole rad is:", rad);
                hull(){
                translate([0,unit*1,0])
                    cylinder(r=rad+clearance, h=10, $fn=48, center=false);
                translate([0,-unit*1,0])
                    cylinder(r=rad+clearance, h=10, $fn=48, center=false);
                }
            }
        }
    //translate([0,airflow/2,0]) rotate([0,0,90])
     //   side_plate();
   // holes & connecting plate
    inter = openingside*1.06;
    start = 36.5;
    for (i=[0:2]){
        translate([-6.5, start+i*inter, 1.8])
            difference(){
            cylinder(r=1.7, h=1.8, center=true, $fn=12);
            cylinder(r=0.9, h=1.9, center=true);
            }
    }
    difference(){
    translate([0, airflow/2+12.5, gap/2])
        cube([19+extracut,59,gap], center=true);
        for (i=[0:2]){
            translate([-6.5, start+i*inter, 0]) 
                cylinder(r=0.9, h=10, center=true);
        }
    }
}

module small_switch(box=[13, 5.4, 6], connect=[11.5,2.5,5]){
    // for insert with flush face
    difference(){
        union(){
            cube(box, center=true);
            translate([2.5, 0, box[2]/2]) rotate([90,0,0])
                cylinder(r=.5, h=3.1, $fn=10, center=true);
            translate([-0.5 ,0, -box[2]/2 - connect[2]/2])
                cube(connect, center=true);
            translate([0,0,-box[0]*2.5])
                cylinder(r=connect[1]/2, h=box[0]*5, $fn=6, center=true);
        }
    translate([box[0]/2 - 0.5, 0, box[2]/2 - 0.5])
        cube([1.5, 3.65, 1.5], center=true);
    }
}

module end_plate_motor(){
    difference(){
        union(){
            end_plate();
            translate([13.65,3,15])
                minkowski(){
                cube([26,13,26], center=true);
                cylinder(r=2, h=.1, $fn=16);
                }
        }
        translate([28+4,3,15]) rotate([-90,0,270])
            #cam(extracut=5);
        //translate([28+4,1.7,15]) rotate([-90,0,270])
        //    cam();
        translate([29-13,3,21]) rotate([-90,0,270])
            #motorbox();
        translate([29-13,3,24]) rotate([-90,0,270])
            cylinder(r=6, h=30, center=true);
        translate([29-3,3,13.5]) rotate([-90,0,270])
            small_switch();
    }
}
   
module plate_air_parts(){
    // for printing the parts
    translate([38,0,0]) rotate([0,0,0])
        end_plate_motor();
    mirror([ 1, 0, 0 ]) { 
    translate([38,0,0]) rotate([0,0,0])
         end_plate(); }
    translate([-57,37,2]) rotate([180,0,90])   side_plate();
    mirror([ 1, 0, 0 ]) { 
    translate([18,37,2]) rotate([180,0,90])   side_plate(); }
    translate([21.5,-37,0])
        side_plate(insider=0);
    mirror([ 1, 0, 0 ])
        translate([21.5,-37,0])
            side_plate(insider=0);
    translate([86,-37,0])
        cam(ht=5);
    translate([50,25,0]) rotate([0,0,180]) louvers();
}

module lifts(){
        linear_extrude(convexity=10, height=3){
	    projection(cut = true){
            translate([0,0,-40.5]) rotate([0,0,90])
	            cbracket(z=travelwheel/2, bs=1.5);
	    }
    }
}

