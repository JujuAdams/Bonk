// Feather disable all

/// @param capsule
/// @param x1
/// @param y1
/// @param z1
/// @param x2
/// @param y2
/// @param z2

function BonkRaycastCapsule(_capsule, _x1, _y1, _z1, _x2, _y2, _z2)
{
    static _nullCoordiante = __Bonk().__nullCoordiante;
    static _coordinate     = new __BonkClassCoordinate();
    
    with(_capsule)
    {
        var _capsuleX = x;
        var _capsuleY = y;
        var _capsuleRadius = radius;
        
        var _capsuleZMin = z - 0.5*height + radius;
        var _capsuleZMax = z + 0.5*height - radius;
        
        var _axisLength = height - 2*radius;
    }
    
    var _dX = _x2 - _x1;
    var _dY = _y2 - _y1;
    var _dZ = _z2 - _z1;
    
    var _vX = _x1 - _capsuleX;
    var _vY = _y1 - _capsuleY;
    var _vZ = _z1 - _capsuleZMin;
    
    var _axisLengthSqr = _axisLength*_axisLength;
    var _rayLengthSqr  = _dX*_dX + _dY*_dY + _dZ*_dZ;
    var _vectorLenSqr  = _vX*_vX + _vY*_vY + _vZ*_vZ;
    
    var _dotAxisRay = _axisLength*_dZ;
    var _dotAxisV   = _axisLength*_vZ;
    var _dotRayV    = _dX*_vX + _dY*_vY + _dZ*_vZ;
    
    //Set up a new quadratic solution for the cylindrical body of the capsule
    var _a = _axisLengthSqr*_rayLengthSqr - _dotAxisRay*_dotAxisRay;
    var _b = _axisLengthSqr*_dotRayV      - _dotAxisV*_dotAxisRay;
    var _c = _axisLengthSqr*_vectorLenSqr - _dotAxisV*_dotAxisV - _axisLengthSqr*_capsuleRadius*_capsuleRadius;
    
    var _discriminant = _b*_b - _a*_c;
    if (_discriminant < 0) return _nullCoordiante;
    
    //Handle rays that start inside the capsule
    _discriminant = sqrt(_discriminant);
    if (-_b < _discriminant)
    {
        _discriminant *= -1;
    }
    
    var _t = (-_b - _discriminant) / _a;
    
    //Test if the closest point on the axis is outside the inner line segment
    var _axisZ = _dotAxisV + _t*_dotAxisRay;
    if ((_axisZ <= 0) || (_axisZ >= _axisLengthSqr))
    {
        //Choose a sphere centre depending on which end of the capsule we're looking at
        var _vZMax = (_axisZ <= 0)? _vZ : _z1 - _capsuleZMax;
        
        //Set up a new quadratic solution for the caps
        var _a = _rayLengthSqr;
        var _b = _dX*_vX + _dY*_vY + _dZ*_vZMax;
        var _c = (_vX*_vX + _vY*_vY + _vZMax*_vZMax) - _capsuleRadius*_capsuleRadius;
        
        var _discriminant = _b*_b - _a*_c;
        if (_discriminant < 0)
        {
            return _nullCoordiante;
        }
        
        _t = (-_b - sqrt(_discriminant)) / _a;
    }
    
    if ((_t < 0) || (_t > 1))
    {
        return _nullCoordiante;
    }
    
    with(_coordinate)
    {
        x = _x1 + _t*_dX;
        y = _y1 + _t*_dY;
        z = _z1 + _t*_dZ;
    }
    
    return _coordinate;
}