PI = 3.141592653589793;
golden_ratio = (1 + sqrt(5)) / 2;

// Convert radians to degrees
function rad_to_deg(rad) = rad * 180 / PI;

function points(r, num_points) = 
    let (step = 360 / num_points)
    [for(angle = [0 : step : 360]) [r * cos(angle), r * sin(angle)]];
    

function phi(i, N) = acos(1 - 2 * (i+ 0.5) / N); // Phi stays the same, acos input is in radians but OpenSCAD acos returns degrees

function theta(i) = rad_to_deg(2 * PI * i / golden_ratio); // Convert theta to degrees

function norm(x,y,z, R) = [x/R, y/R, z/R];

function cross(b) = [-b[1], b[0], 0];

module fib_sphere(N, r) {
    
    surface_area = 4 * PI * r * r;
    area_per = surface_area / N;
    R = sqrt(area_per / PI); //assumes circle, should give a decent overlap
    
    for(n = [0:N-1]) {
        p = phi(n, N); // OpenSCAD's trig functions use degrees, acos result is directly in degrees
        t = theta(n);
        
        x = sin(p) * cos(t); // sin and cos expect degrees
        y = sin(p) * sin(t); // Adjusted accordingly
        z = cos(p);          // cos expects degrees
        
        direction = norm(x, y, z, r);
        axis = cross(direction);
        
        angle = acos(z / (sqrt(x*x + y*y + z*z)));
        
        translate([x*r, y*r, z*r])
          rotate(angle, axis)
                linear_extrude(r/20) {
                    polygon(points(R, 6));
                }
//            sphere(R, $fn=50);
    }
}

fib_sphere(1000, 10); // Example usage
