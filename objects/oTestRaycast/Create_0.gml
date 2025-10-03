// Feather disable all

gridScale = 64;

//lineA = new BonkLine(4.5, 1.5, 1.5,   7.5, 1.5, 4.5); //x-axis positive
//lineA = new BonkLine(4.5, 1.5, 1.5,   7.5, 1.5, 4.5); //xz
//lineA = new BonkLine(4.5, 1.5, 1.5,   4.5, 1.5, 4.5); //z
//lineA = new BonkLine(4.5, 1.5, 1.5,   4.5, 4.5, 4.5); //yz
//lineA = new BonkLine(4.5, 1.5, 1.5,   4.5, 4.5, 1.5); //y
//lineA = new BonkLine(4.5, 1.5, 1.5,   7.5, 4.5, 1.5); //xy
//lineA = new BonkLine(4.5, 1.5, 1.5,   7.5, 4.5, 4.5); //xyz
//lineA = new BonkLine(4.5, 4.5, 4.5,   4.5 + irandom_range(-4, 4), 4.5 + irandom_range(-4, 4), 4.5 + irandom_range(-4, 4)); //random

lineA = new BonkLine(4.5, 4.5, 4.5,   3.5, 7.5, 2.5); //test case
pointArrayA = __BonkSupercover(lineA.x1, lineA.y1, lineA.z1,   lineA.x2, lineA.y2, lineA.z2);

show_debug_message(lineA);
show_debug_message(pointArrayA);

world = new BonkStructWorld(640, 640, 640, 64, 64, 64);
world.Add(new BonkStructAAB(100, 100, 100, 64, 64, 64));
world.Add(new BonkStructAAB(room_width/2, room_height/2, -10,   room_width, room_height, 10));

lineB = new BonkLine(100, 100, 150,   100, 100, 0);