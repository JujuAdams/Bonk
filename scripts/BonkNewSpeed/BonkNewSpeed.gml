/// @param xSpeed
/// @param ySpeed
/// @param zSpeed
/// @param reactionStruct

function BonkNewSpeed(_xSpeed, _ySpeed, _zSpeed, _reactionStruct)
{
    static _result = {
        x: 0,
        y: 0,
        z: 0,
    };
    
    with(_result)
    {
        if (_reactionStruct.collision)
        {
            var _normalX = _reactionStruct.dX;
            var _normalY = _reactionStruct.dY;
            var _normalZ = _reactionStruct.dZ;
            var _normalSqrLength = _normalX*_normalX + _normalY*_normalY + _normalZ*_normalZ
            
            if (_normalSqrLength <= 0)
            {
                x = _xSpeed;
                y = _ySpeed;
                z = _zSpeed;
            }
            else
            {
                var _coeff = dot_product_3d(_xSpeed, _ySpeed, _zSpeed, _normalX, _normalY, _normalZ) / _normalSqrLength;
                x = _xSpeed - _coeff*_normalX;
                y = _ySpeed - _coeff*_normalY;
                z = _zSpeed - _coeff*_normalZ;
            }
        }
        else
        {
            x = 0;
            y = 0;
            z = 0;
        }
    }
    
    return _result;
}