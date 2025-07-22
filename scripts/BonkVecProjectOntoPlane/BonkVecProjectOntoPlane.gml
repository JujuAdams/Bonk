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
    
    var _normalSqrLength = _normalX*_normalX + _normalY*_normalY + _normalZ*_normalZ
    if (_normalSqrLength <= 0)
    {
        _coeff = 0;
    }
    else
    {
        var _coeff = dot_product_3d(_vectorX, _vectorY, _vectorZ, _normalX, _normalY, _normalZ) / _normalSqrLength;
    }
    
    _result.x = _vectorX - _coeff*_normalX;
    _result.y = _vectorY - _coeff*_normalY;
    _result.z = _vectorZ - _coeff*_normalZ;
    
    return _result;
}