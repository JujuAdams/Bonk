sphere.Draw(BonkBoolSphereInTriangle(sphere, triangle)? c_lime : c_red, true);
triangle.Draw(c_white, true);

var _reaction = BonkSphereInTriangle(sphere, triangle);
if (_reaction.collision)
{
    var _dX = _reaction.dX;
    var _dY = _reaction.dY;
    var _dZ = _reaction.dZ;
    
    var _dist = sqrt(_dX*_dX + _dY*_dY + _dZ*_dZ);
    _dX /= _dist;
    _dY /= _dist;
    _dZ /= _dist;
    
    var _x = sphere.x + sphere.radius*_dX;
    var _y = sphere.y + sphere.radius*_dY;
    var _z = sphere.z + sphere.radius*_dZ;
    
    UggArrow(_x, _y, _z,
             _x - _reaction.dX, _y - _reaction.dY, _z - _reaction.dZ,
             1, undefined, undefined, true);
}