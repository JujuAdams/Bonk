/// @param vectorX
/// @param vectorY
/// @param vectorZ
/// @param normalX
/// @param normalY
/// @param normalZ

function BonkVecProjectOntoPlane(_vectorX, _vectorY, _vectorZ, _normalX, _normalY, _normalZ)
{
    static _result = {
        x: 0,
        y: 0,
        z: 0,
    };
    
    //Ensure the normal is normalized :)
    var _normalLength = sqrt(_normalX*_normalX + _normalY*_normalY + _normalZ*_normalZ);
    
    //If the normal is of length 0 then return the original vector
    if (_normalLength <= 0)
    {
        _result.x = _vectorX;
        _result.y = _vectorY;
        _result.z = _vectorZ;
        return _result;
    }
    
    _normalX /= _normalLength;
    _normalY /= _normalLength;
    _normalZ /= _normalLength;
    
    //Choose a dummy vector
    if ((_normalX != 0) || (_normalY != 0))
    {
        var _tempX = 0;
        var _tempY = 0;
        var _tempZ = 1;
    }
    else
    {
        var _tempX = 0;
        var _tempY = 1;
        var _tempZ = 0;
    }
    
    //Find a tangent to the normal
    var _tangentX = _normalZ*_tempY - _normalY*_tempZ;
    var _tangentY = _normalX*_tempZ - _normalZ*_tempX;
    var _tangentZ = _normalY*_tempX - _normalX*_tempY;
    
    //Find a vector perpendicular to the tangent and the normal
    var _bitangentX = _normalZ*_tangentY - _normalY*_tangentZ;
    var _bitangentY = _normalX*_tangentZ - _normalZ*_tangentX;
    var _bitangentZ = _normalY*_tangentX - _normalX*_tangentY;
    
    //Project the vector onto the tangent and bitagent (effectively basis vectors)
    var _tangentDot   = _vectorX*_tangentX   + _vectorY*_tangentY   + _vectorZ*_tangentZ;
    var _bitangentDot = _vectorX*_bitangentX + _vectorY*_bitangentY + _vectorZ*_bitangentZ; 
    
    //Convert the projected vector back into global coordinates
    _result.x = _tangentDot*_tangentX + _bitangentDot*_bitangentX;
    _result.y = _tangentDot*_tangentY + _bitangentDot*_bitangentY;
    _result.z = _tangentDot*_tangentZ + _bitangentDot*_bitangentZ;
    
    return _result;
}