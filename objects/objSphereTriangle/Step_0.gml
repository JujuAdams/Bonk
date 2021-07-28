with(sphere)
{
    if (keyboard_check(ord("J"))) x -= 0.5;
    if (keyboard_check(ord("L"))) x += 0.5;
    if (keyboard_check(ord("I"))) y -= 0.5;
    if (keyboard_check(ord("K"))) y += 0.5;
    if (keyboard_check(ord("U"))) z -= 0.5;
    if (keyboard_check(ord("O"))) z += 0.5;
}