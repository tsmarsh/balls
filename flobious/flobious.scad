num = 300; //10 + (300 * abs(sin(360 * $t)));
radius = 24;


golden_ratio = (1 + sqrt(5 + (sin(360 * $t)/10))) / 2;


function points(r, num_points) = let (step = 360 / num_points)
    [for (angle = [0 : step : 360]) [r * cos(angle), r * sin(angle)]];


function phi(i, N) = acos(1 - 2 * (i + 0.5) / N);

function theta(i) = 360 * i / golden_ratio;

function norm(x, y, z, R) = [x / R, y / R, z / R];

function shade(k, N, start, end) = start - (start - end) * k / (N - 1);


module smooth_poly(R, r,  num) {
  hull() {
        for (p = points(R, num)) {
            translate(p)
                sphere(r/20, $fn = 50);
        }
  }
}

module fib_poly(N, r, R) {

    for (n = [0:N - 1]) {
        p = phi(n, N) ;
        t = theta(n);

        x = sin(p) * cos(t);
        y = sin(p) * sin(t);
        z = cos(p);

        direction = norm(x, y, z, r);
        axis = cross([0, 0, 1], direction);

        angle = acos(z / (sqrt(x * x + y * y + z * z)));

        color([shade(n, N, 1, 0), shade(n, N, 1, 1/3), shade(n, N, 1, 2/3)])
            translate([x * r, y * r, z * r])
                rotate(angle, axis)
                     rotate([0, 0, 120 * $t])
                         smooth_poly(R,r, 6);
 
    }
               
}

surface_area = 4 * PI * radius * radius;
area_per = surface_area / num;
R = sqrt(area_per / PI) * 0.5;

difference() {
    fib_poly(num, radius, R);
}