
// circular cam generator
// use cubes to make a smooth circular arangement of bumps

outsiderad = 25;
insiderad = 22;
pi = 3.141592653589793;
thickness = outsiderad - insiderad;
spot = insiderad + thickness / 2;
circumf = outsiderad * 2 * pi;
lift = 5;  					// peak-to-trough height of bumps
detail = 45;				// how many sections make up each valley-to-peak, i.e. resolution
peaks = 4;					// how many upright bumps
deg_per_step = 360 / (detail * peaks);
chunk = circumf / (detail * peaks);
echo("deg_per_step is: ", deg_per_step);

for (m=[0:deg_per_step:359]){
	//for (i=[0 : (360/peaks)/detail : (360/peaks)]) {		// i = one sinewave iterator
	translate([cos(m)*spot, sin(m)*spot, lift*abs(sin(m))/2]) rotate([0,0,m])
		cube([chunk, thickness, lift*abs(sin(m))], center=true);
}