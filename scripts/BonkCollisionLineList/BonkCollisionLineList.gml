// Feather disable all

/// @param x1
/// @param y1
/// @param z1
/// @param x2
/// @param y2
/// @param z2
/// @param [list]
/// @param [objectXY]
/// @param [objectXZ]

function BonkCollisionLineList(_x1, _y1, _z1, _x2, _y2, _z2, _list = undefined, _objectXY = BonkMaskXY, _objectXZ = BonkMaskXZ)
{
    static _listStatic   = ds_list_create();
    static _listXZStatic = ds_list_create();
    
    if (_list == undefined)
    {
        _list = _listStatic;
        ds_list_clear(_list);
        var _listStart = 0;
    }
    else
    {
        var _listStart = ds_list_size(_list);
    }
    
    var _countXY = collision_line_list(_x1, _y1, _x2, _y2, _objectXY, false, false, _list, false);
    
    if (BONK_INSTANCE_XZ)
    {
        var _listXZ = _listXZStatic;
        collision_line_list(_x1, _z1, _x2, _z2, _objectXZ, false, false, _listXZ, false);
        
        var _i = _countXY-1;
        repeat(_countXY - _listStart)
        {
            var _otherShape = _list[| _i];
            
            var _index = ds_list_find_index(_listXZ, _otherShape.__instanceXZ);
            if (_index < 0)
            {
                ds_list_delete(_list, _i);
            }
            
            --_i;
        }
        
        ds_list_clear(_listXZ);
    }
    
    return _list;
}