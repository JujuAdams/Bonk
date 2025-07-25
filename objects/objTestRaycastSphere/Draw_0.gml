sphere.Draw(c_white);

var _func = function(_line)
{
    var _coordinate = BonkRaycastSphere(sphere, _line.x1, _line.y1, _line.z1, _line.x2, _line.y2, _line.z2);
    _line.Draw(_coordinate.collision? c_red : c_white, true);
    if (_coordinate.collision) UggPoint(_coordinate.x, _coordinate.y, _coordinate.z, c_red);
}

_func(line1);