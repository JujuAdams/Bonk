// Feather disable all

var _funcRandom = function(_min, _max)
{
    return irandom_range(10*_min, 10*_max) / 10;
}

lineA = new BonkLine(_funcRandom(-10, 10), _funcRandom(-10, 10), _funcRandom(-10, 10),
                     _funcRandom(-10, 10), _funcRandom(-10, 10), _funcRandom(-10, 10));
show_debug_message(lineA);
pointArrayA = __BonkSupercover(lineA.x1, lineA.y1, lineA.z1,   lineA.x2, lineA.y2, lineA.z2);
show_debug_message(pointArrayA);