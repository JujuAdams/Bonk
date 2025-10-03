// Feather disable all

/// @param x1
/// @param y1
/// @param z1
/// @param x2
/// @param y2
/// @param z2
/// @param [exclude]
/// @param [array]
/// @param [objectXY]
/// @param [objectXZ]

function BonkCollisionLineList(_x1, _y1, _z1, _x2, _y2, _z2, _exclude = undefined, _array = undefined, _objectXY = BonkMaskXY, _objectXZ = BonkMaskXZ)
{
    static _staticArray = [];
    _array ??= _staticArray;
    
    static _listXYStatic = ds_list_create();
    static _listXZStatic = ds_list_create();
    
    var _listXY = _listXYStatic;
    var _countXY = collision_line_list(_x1, _y1, _x2, _y2, _objectXY, false, false, _listXY, false);
    
    var _index = ds_list_find_index(_listXY, _exclude.id);
    if (_index >= 0)
    {
        ds_list_delete(_listXY, _index);
        --_countXY;
    }
    
    if (BONK_INSTANCE_XZ)
    {
        array_resize(_array, 0);
        
        var _listXZ = _listXZStatic;
        collision_line_list(_x1, _z1, _x2, _z2, _objectXZ, false, false, _listXZ, false);
        
        var _i = 0;
        repeat(_countXY)
        {
            var _otherShape = _listXY[| _i];
            
            var _index = ds_list_find_index(_listXZ, _otherShape.__instanceXZ);
            if (_index >= 0)
            {
                array_push(_array, _otherShape);
            }
            
            ++_i;
        }
        
        ds_list_clear(_listXZ);
    }
    else
    {
        array_resize(_array, _countXY);
        
        var _i = 0;
        repeat(_countXY)
        {
            _array[@ _i] = _listXY[| _i];
            ++_i;
        }
    }
    
    ds_list_clear(_listXY);
    
    return _array;
}