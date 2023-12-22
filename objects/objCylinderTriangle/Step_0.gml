with(cylinder)
{
    if (keyboard_check(ord("J"))) { x1 -= 0.5; x2 -= 0.5; }
    if (keyboard_check(ord("L"))) { x1 += 0.5; x2 += 0.5; }
    if (keyboard_check(ord("I"))) { y1 -= 0.5; y2 -= 0.5; }
    if (keyboard_check(ord("K"))) { y1 += 0.5; y2 += 0.5; }
    if (keyboard_check(ord("U"))) { z1 -= 0.5; z2 -= 0.5; }
    if (keyboard_check(ord("O"))) { z1 += 0.5; z2 += 0.5; }
}