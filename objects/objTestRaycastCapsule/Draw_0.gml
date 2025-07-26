capsule.Draw(c_white, true);

var _func = function(_line)
{
    var _coordinate = BonkRaycastCapsule(capsule, _line.x1, _line.y1, _line.z1, _line.x2, _line.y2, _line.z2);
    _line.Draw(_coordinate.collision? c_red : c_white, true);
    if (_coordinate.collision) UggSphere(_coordinate.x, _coordinate.y, _coordinate.z, 2, c_red);
}
 
_func(line1);
_func(line2);
_func(line3);
_func(line4);
_func(line5);
_func(line6);