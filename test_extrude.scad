
$fn=128;
// extension:
// while going round the circle, relative positons of air and extender
// starting in "just dropped the cargo" or "just initialized the machine" mode:

//			1		2			3			4			5		6
// air-------closed	opening	open		open		open	closing
// extendo- in		extending	out			retracting	in		in

// __picker positions__
// pos 1: dropped card, moving back to pickup position
// pos 2: in pickup position, grabbing card
// pos 3: cargo on sucker, picker still in pickup postion
// pos 4: cargo is being lifted, aligned and protected for travel, picker travel begins
// pos 5: picker traveling with cargo to destination. 
// pos 6: picker in drop-off position, begins drop

// note: we may want to add some wiggle after 6 to reposition in holder
/*

part---- 		extender:					airholes:
				1	2	3	4	5	6		1	2	3	4	5	6
up / on		-				-	-				-	-	-

mid / trans			-		-					-				-

down / off				-					-

'side-1' is the top horizontal section of the hexagon.
We go clockwise from there, viewed with normal axis

relative seperation:		1	2	3	4	5	6
			max+		-					
			mid+							-
			none			-			-
			mid-					-
			max-				-
*/

// generate the 4 kinds of sections we need
// then combine them into the 6-sided cylinder used to cut
// from inside the 'sleeve' that moves up and down
module beepbeep (){
	x1=20;
	x2=x1;
	q1=20;
	q2=q1;
	h1=50;
	h2=h1;
	rot=30;
	rot2=0;
	
	intersection(){
		cylinder(r1=x1, r2=x2, h=h1, center=true, $fn=6);
		rotate([0,rot,rot2]) translate([0,0,h1/2-1])
			cylinder(r1=q1, r2=q2, h=h2, center=true);
		//rotate([0,rot,rot2]) translate([0,0,-h1/2+1])
		//	cylinder(r1=q1, r2=q2, h=h2, center=true);
	}
	
	translate([x1*3, 0,0])
	intersection(){
		cylinder(r1=x1, r2=x2, h=h1, center=true);
		rotate([0,rot,rot2])
			rotate_extrude()
				translate([20,0,0])
					circle(r = 10);
	}
}

beepbeep();