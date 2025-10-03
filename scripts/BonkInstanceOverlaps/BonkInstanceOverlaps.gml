// Feather disable all

/// @param shape
/// @param dX
/// @param dY
/// @param dZ
/// @param [list]
/// @param [objectXY]
/// @param [objectXZ]

function BonkInstanceOverlaps(_shape, _dX, _dY, _dZ, _list = undefined, _objectXY = BonkMaskXY, _objectXZ = BonkMaskXZ)
{
    static _listStatic = ds_list_create();
    static _listXZStatic = ds_list_create();
    
    _list ??= _listStatic;
    ds_list_clear(_list);
    
    if (not variable_instance_exists(_shape, "id"))
    {
        __BonkError("Can only use BonkInstanceOverlaps() with instances");
    }
    
    with(_shape)
    {
        var _countXY = instance_place_list(x + _dX, y + _dY, _objectXY, _list, false);
    }
    
    if (BONK_INSTANCE_XZ)
    {
        //Remove instances that don't also collide on the XZ plane
        
        var _listXZ = _listXZStatic;
        
        with(_shape.__instanceXZ)
        {
            instance_place_list(x + _dX, y + _dZ, _objectXZ, _listXZ, false);
        }
        
        var _i = _countXY-1;
        repeat(_countXY)
        {
            var _index = ds_list_find_index(_listXZ, _list[| _i].__instanceXZ);
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