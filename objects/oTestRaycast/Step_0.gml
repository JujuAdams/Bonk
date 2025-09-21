// Feather disable all

if (keyboard_check_pressed(ord("L")))
{
    lineA = new BonkLine(4 + random(1), 4.5 + random(1), 4.5 + random(1),
                         4.5 + random_range(-4, 4), 4.5 + random_range(-4, 4), 4.5 + random_range(-4, 4));
    pointArrayA = Supercover3D(lineA.x1, lineA.y1, lineA.z1,   lineA.x2, lineA.y2, lineA.z2);
    
    show_debug_message(lineA);
    show_debug_message(pointArrayA);
}