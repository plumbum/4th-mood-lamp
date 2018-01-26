// Thread lib https://www.thingiverse.com/thing:2158656
use <lib/ISOThread.scad>

thickness = 1.4;
thickness_bulb = 1.1;
bulb_d = 100;
bulb_scale = 1.5; // 1
bulb_correction = -1; // 6

stand_d1 = 80;
stand_d2 = 70;
stand_h = 20;

thread_d = 67;
thread_in_d = 60;
thread_h = 5;
thread_pitch = 4;

connector_height = 10;
connector_width = 14; // 16;
connector_deep = 0; //0.4;
// 14 -> 0.4
// 16 -> 0.5
// 20 -> 1
// 34 -> 4

// color("LightCyan") bulb();
// color("DarkGreen") 
//    stand();

#bulb();
stand();

module bulb() {
    
    difference() {
        translate([0,0,bulb_scale*bulb_d/2+bulb_correction])
            scale([1, 1, bulb_scale])
            difference() {
                sphere(d=bulb_d, $fn=80);
                sphere(d=bulb_d-thickness_bulb*2, $fn=80);
            }
        translate([0, 0, -stand_h]) {
            cylinder(h=stand_h*2, d=bulb_d);
            cylinder(h=stand_h*2+thickness_bulb, d=thread_d+thickness*2);
        }
    }
    translate([0,0,stand_h]) inner_thread();
}

module stand() {
    
    difference() {
        _stand();
        translate([0,0,thickness]) {
            cylinder(h=stand_h-thickness*2, d1=stand_d1-thickness*2, d2=stand_d2-thickness*2);
            cylinder(h=stand_h, d=thread_in_d);

        }
        if (connector_width > 0) {
            translate([-connector_width/2, -20-stand_d2/2, thickness])
                cube([connector_width, 40, connector_height]);
        }
    }
    translate([0,0,stand_h]) outer_thread();

    intersection() {
        translate([0, -stand_d2/2+connector_deep, 0]) rotate([0,0,180]) connectors_wall();
        _stand();

    }
}

module connectors_wall() {
    difference() {
        translate([-(connector_width+thickness*2)/2, 0, 0])
            cube([connector_width+thickness*2, 10, connector_height+thickness*2]);
        translate([-(connector_width)/2, thickness, thickness])
            cube([connector_width, 10, connector_height]);

    }
}

module _stand() {
    cylinder(h=stand_h, d1=stand_d1, d2=stand_d2, $fn=70);
}

// Thread for stand
module outer_thread() {
    difference() {
        iso_thread(  // Generate ISO / UTS thread, centred 0,0,
            m=thread_d,    // M size, mm, (outer diameter)
            p=thread_pitch,  // Pitch, mm (0 for standard coarse pitch)
            l=thread_h,   // length
            t=-0.2,    // tolerance to add (for internal thread)
            cap=1  // capped ends. If uncapped, length is half a turn more top and bottom
        );

        translate([0,0,-0.05])
            // thread_out_centre(thread_d-thickness*2,thread_h+0.1);
            cylinder(h=thread_h+0.1, d=thread_in_d);

    }
}


module inner_thread() {
    difference() {
        cylinder(h=thread_h-0.1, d=thread_d+thickness*2);
        // translate([0,0,-0.05]) cylinder(h=thread_h+0.1, d=thread_d);
        iso_thread(  // Generate ISO / UTS thread, centred 0,0,
            m=thread_d,    // M size, mm, (outer diameter)
            p=thread_pitch,  // Pitch, mm (0 for standard coarse pitch)
            l=thread_h,   // length
            t=0.3,    // tolerance to add (for internal thread)
            cap=1  // capped ends. If uncapped, length is half a turn more top and bottom
        );
    }
}

