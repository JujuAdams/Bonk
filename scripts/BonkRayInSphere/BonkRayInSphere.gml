// Feather disable all

/// @param ray
/// @param sphere

function BonkRayInSphere(_ray, _sphere)
{
    with(_ray)
    {
        var _centre = [_sphere.x, _sphere.y, _sphere.z];
        var _radius = _sphere.radius;
        var _ray_a  = [x1, y1, z1];
        var _ray_b  = [x2, y2, z2];
        
        var _dir = BonkVecSubtract( _ray_b, _ray_a);
        var _length = BonkVecLength(_dir);
        
        if (_length <= 0) return false;
        
        _dir = BonkVecMultiply(_dir, 1/_length);
        var _local = BonkVecSubtract(_ray_a, _centre);
        var _b = BonkVecDot(_local, _dir);
        var _c = BonkVecSquareLength(_local) - _radius*_radius;
        
        var _discriminant = _b*_b - _c;
        if (_discriminant < 0) return false;
        
        var _t_min = -_b - sqrt(_discriminant);
        var _t_max = -_b + sqrt(_discriminant);
        
        return ((_length < _t_min) && (_t_min >= 0) && (_t_max >= 0));
    }
    
    return false;
}