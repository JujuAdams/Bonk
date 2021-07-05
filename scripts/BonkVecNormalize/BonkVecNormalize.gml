/// @param vector

function BonkVecNormalize(_a)
{
    var _x = _a[0];
    var _y = _a[1];
    var _z = _a[2];
    
    var _coefficient = 1 / sqrt(_x*_x + _y*_y + _z*_z);
    
    return [_x*_coefficient, _y*_coefficient, _z*_coefficient];
}