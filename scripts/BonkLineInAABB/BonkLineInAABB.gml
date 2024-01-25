// Feather disable all

/// @param line
/// @param aabb

function BonkLineInAABB(_line, _aabb)
{
    with(_line)
    {
        var _line0 = [x1, y1, z1];
        var _line1 = [x2, y2, z2];
        
        with(_aabb)
        {
            var _aabb_centre    = [x, y, z];
            var _aabb_half_dims = [xHalfSize, yHalfSize, zHalfSize];
        }
        
        var _dir = BonkVecSubtract( _line1, _line0 );
        if ((_dir[0] == 0) && (_dir[1] == 0) && (_dir[2] == 0)) return false;
        
        var _aabb_min = BonkVecSubtract(_aabb_centre, _aabb_half_dims);
        var _aabb_max = BonkVecAdd(_aabb_centre, _aabb_half_dims);
        
        var _t_min = undefined;
        var _t_max = undefined;
        
        if (_dir[0] != 0)
        {
            var _t_min = (_aabb_min[0] - _line0[0]) / _dir[0];
            var _t_max = (_aabb_max[0] - _line0[0]) / _dir[0];
            if (_t_min > _t_max) { var _temp = _t_max; _t_max = _t_min; _t_min = _temp; }
        }
        
        if (_dir[1] != 0)
        {
            var _t_y_min = (_aabb_min[1] - _line0[1]) / _dir[1];
            var _t_y_max = (_aabb_max[1] - _line0[1]) / _dir[1];
            if (_t_y_min > _t_y_max) { var _temp = _t_y_max; _t_y_max = _t_y_min; _t_y_min = _temp; }
        
            if (_t_min == undefined)
            {
                _t_min = _t_y_min;
                _t_max = _t_y_max;
            }
            else
            {
                if ((_t_min > _t_y_max) || ( _t_y_min > _t_max)) return false;
                if (_t_y_min > _t_min) _t_min = _t_y_min;
                if (_t_y_max < _t_max) _t_max = _t_y_max;
            }
        }
        
        if (_dir[2] != 0)
        {
            var _t_z_min = (_aabb_min[2] - _line0[2]) / _dir[2];
            var _t_z_max = (_aabb_max[2] - _line0[2]) / _dir[2];
            if (_t_z_min > _t_z_max) { var _temp = _t_z_max; _t_z_max = _t_z_min; _t_z_min = _temp; }
        
            if (_t_min == undefined)
            {
                _t_min = _t_z_min;
                _t_max = _t_z_max;
            }
            else
            {
                if ((_t_min > _t_z_max) || (_t_z_min > _t_max)) return false;
                if (_t_z_min > _t_min) _t_min = _t_z_min;
                if (_t_z_max < _t_max) _t_max = _t_z_max;
            }
        }
        
        if (_t_min == undefined) return false;
        
        var _t = _t_min;
        if ((_t_min <= 0) || (_t_min >= 1))
        {
            if ((_t_max <= 0) || (_t_max >= 1)) return false;
            var _t = _t_max;
        }
        
        var _point = BonkVecAdd(_line0, BonkVecMultiply(BonkVecSubtract(_line1, _line0), _t));
        return __BonkAABBPointInsideMinMax(_point, _aabb_min, _aabb_max);
    }
}