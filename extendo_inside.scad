use <inside_tracker.scad>;

// lower extending tube
rotate_extrude(convexity=10, center=true, $fn=128){
      translate([sleeve_inside-, 0, mid])
           polygon(points=[[0, 0],
                            [0, mid],
                            [1, mid],
                            [1 + 4.36/2, mid - 4.36/2],
                            [4.36, mid],
                            [5.36, mid],
                            [10, mid - 10],
                            [10, mid - 11],
                            [9, mid - 11],
                            [4, mid - 16],
                            [5.3, mid - 17.5],
                            [4, mid - 19],
                            [4, -mid],
                            [0, -mid]]);