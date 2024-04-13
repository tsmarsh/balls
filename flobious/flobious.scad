num = 300;
radius = 24;


golden_ratio = (1 + sqrt(5)) / 2;


function points(r, num_points) =
let (step = 360 / num_points)
    [for (angle = [0 : step : 360]) [r * cos(angle), r * sin(angle)]];


function phi(i, N) = acos(1 - 2 * (i + 0.5) / N);

function theta(i) = 360 * i / golden_ratio;

function norm(x, y, z, R) = [x / R, y / R, z / R];


module fib_poly(N, r, R) {

    for (n = [0:N - 1]) {
        p = phi(n, N) ;
        t = theta(n);

        x = sin(p * $t) * cos(t);
        y = sin(p) * sin(t);
        z = cos(p);

        direction = norm(x, y, z, r);
        axis = cross([0, 0, 1], direction);

        angle = acos(z / (sqrt(x * x + y * y + z * z)));

        color([1 * (n / N), 2 / 3, 1 / 10])
            translate([x * r, y * r, z * r * (sin(720 * $t))])
                rotate(angle, axis)
                    linear_extrude(r / 20) {
                        rotate([0, 0, 60 * sin(720 * $t)])
                            polygon(points(R, 6));
                    }
    }
}

$vpt = [4, 4, 2];

$vpr = [60 * sin(720 * $t), 0, 360 * $t];

$vpd = 180;

surface_area = 4 * PI * radius * radius;
area_per = surface_area / num;
R = sqrt(area_per / PI) * 1;

difference() {
    fib_poly(num, radius, R);
}