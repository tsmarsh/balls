$fn=100;
num = 200;
radius = 25;


golden_ratio = (1 + sqrt(5)) / 2;


function points(r, num_points) = 
    let (step = 360 / num_points)
    [for(angle = [0 : step : 360]) [r * cos(angle), r * sin(angle)]];
    

function phi(i, N) = acos(1 - 2 * (i+ 0.5) / N);

function theta(i) = 360 * i / golden_ratio;

function norm(x,y,z, R) = [x/R, y/R, z/R];

module fib_sphere(N, r, R) {
        
    for(n = [0:N-1]) {
        p = phi(n, N);
        t = theta(n);
        
        x = sin(p) * cos(t); 
        y = sin(p) * sin(t); 
        z = cos(p);          
        
        direction = norm(x, y, z, r);
        axis = cross([0,0,1], direction);
        
        angle = acos(z / (sqrt(x*x + y*y + z*z)));
        
        translate([x*r, y*r, z*r])
            sphere(R, $fn=30);
    }
}

module fib_poly(N, r, R) {
        
    for(n = [0:N-1]) {
        p = phi(n, N);
        t = theta(n);
        
        x = sin(p) * cos(t); 
        y = sin(p) * sin(t); 
        z = cos(p);          
        
        direction = norm(x, y, z, r);
        axis = cross([0,0,1], direction);
        
        angle = acos(z / (sqrt(x*x + y*y + z*z)));
        
        translate([x, y, z])
          rotate(angle, axis)
                linear_extrude(r) {
                    rotate([0,0,30])
                    polygon(points(R, 6));
                }
    }
}



surface_area = 4 * PI * radius * radius;
area_per = surface_area / num;
R = sqrt(area_per / PI) * 1.2;
    
difference() {
    sphere(radius + (R*0.8), $fn = 100);
    sphere(radius - (R*0.7));
    fib_sphere(num, radius, R);
}

translate([0,0,0-0.2])
union(){
translate([0,0,-radius*1.25])
cylinder(1, radius / 2,radius / 2);

difference() {
translate([0,0,-radius*1.25])
    for(r = [2: 2: radius / 2]){
        difference() {
                cylinder(radius / 2, r, r);
                cylinder(radius / 2, r-1, r-1);
        }
    }

    sphere(radius + (R*0.8), $fn = 100);
}
}


    


