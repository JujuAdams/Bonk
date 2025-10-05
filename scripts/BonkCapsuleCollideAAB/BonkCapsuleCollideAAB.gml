// Feather disable all

/// @param capsule
/// @param aab
/// @param [struct]

function BonkCapsuleCollideAAB(_capsule, _aab, _struct = undefined)
{
    static _staticStruct = new BonkResultCollide();
    var _reaction = _struct ?? _staticStruct;
    
    with(_capsule)
    {
        var _capsuleRadius = radius;
        var _capsuleX      = x;
        var _capsuleY      = y;
        var _capsuleZ      = z;
        var _capsuleZMin   = _capsuleZ - 0.5*height + radius;
        var _capsuleZMax   = _capsuleZ + 0.5*height - radius;
    }
    
    with(_aab)
    {
        var _aabX = clamp(_capsuleX, x - 0.5*xSize, x + 0.5*xSize);
        var _aabY = clamp(_capsuleY, y - 0.5*ySize, y + 0.5*ySize);
        var _aabZ = clamp(_capsuleZ, z - 0.5*zSize, z + 0.5*zSize);
    }
    
    var _capsuleClosestZ = clamp(_aabZ, _capsuleZMin, _capsuleZMax);
    
    var _dX = _aabX - _capsuleX;
    var _dY = _aabY - _capsuleY;
    var _dZ = _aabZ - _capsuleClosestZ;
    
    var _dist = sqrt(_dX*_dX + _dY*_dY + _dZ*_dZ);
    if ((_dist <= 0) || (_dist >= _capsuleRadius))
    {
        return _reaction.__Null();
    }
    
    var _coeff = _capsuleRadius / _dist;
    var _capsuleClosestX = _coeff*_dX + _capsuleX;
    var _capsuleClosestY = _coeff*_dY + _capsuleY;
    var _capsuleClosestZ = _coeff*_dZ + _capsuleClosestZ;
    
    with(_reaction)
    {
        shape = _aab;
        
        dX = _aabX - _capsuleClosestX;
        dY = _aabY - _capsuleClosestY;
        dZ = _aabZ - _capsuleClosestZ;
    }
    
    return _reaction;
}