// Feather disable all

/// @param line
/// @param wall

function BonkLineInWall(_line, _wall)
{
    with(_wall)
    {
        var _normalX = y2 - y1;
        var _normalY = x1 - x2;
        var _d = 1 / sqrt(_normalX*_normalX + _normalY*_normalY);
        _normalX *= _d;
        _normalY *= _d;
        
        var _planeDistance = x1*_normalX + y1*_normalY;
        
        var _dX = _line.x2 - _line.x1;
        var _dY = _line.y2 - _line.y1;
        
        var _n_dot_d = dot_product(_normalX, _normalY, _dX, _dY);
        if (abs(_n_dot_d) == 0) return false;
        
        var _t = (_planeDistance - dot_product(_normalX, _normalY, _line.x1, _line.y1)) / _n_dot_d;
        
    	if ((_t < 0) || (_t > 1)) return false; //Exit if the point of collision is off the line
        
        var _z = _line.z1 + _t*(_line.z2 - _line.z1);
        if ((_z < z1) || (_z > z2)) return false;
        
        var _x = _line.x1 + _t*_dX;
        var _y = _line.y1 + _t*_dY;
        
        var _dX = x2 - x1;
        var _dY = y2 - y1;
        
        _x -= x1;
        _y -= y1;
        
        var _dot = (_x*_dX + _y*_dY) / (_dX*_dX + _dY*_dY);
        
        return ((_dot >= 0) && (_dot <= 1));
    }
}