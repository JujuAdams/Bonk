triangle.Draw(c_white);

var _func = function(_line)
{
    var _coordinate = BonkLineHitTriangle(triangle, _line.x1, _line.y1, _line.z1, _line.x2, _line.y2, _line.z2);
    _line.Draw(_coordinate.collision? c_red : c_white, true);
    if (_coordinate.collision)
    {
        UggSphere(_coordinate.x, _coordinate.y, _coordinate.z, 2, c_red);
        UggRayWithArrow(_coordinate.x, _coordinate.y, _coordinate.z,
                        _coordinate.normalX, _coordinate.normalY, _coordinate.normalZ,
                        c_red, 1, true);
    }
}
 
_func(line1);
_func(line2);
_func(line3);
_func(line4);
_func(line5);