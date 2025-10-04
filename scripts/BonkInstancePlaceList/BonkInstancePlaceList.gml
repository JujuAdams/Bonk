// Feather disable all

/// @param bonkInstance
/// @param dX
/// @param dY
/// @param dZ
/// @param [groupFilter]
/// @param [list]
/// @param [objectXY]
/// @param [objectXZ]

function BonkInstancePlaceList(_bonkInstance, _dX, _dY, _dZ, _groupFilter = undefined, _list = undefined, _objectXY = BonkObjectXY, _objectXZ = BonkObjectXZ)
{
    static _listStatic = ds_list_create();
    static _listXZStatic = ds_list_create();
    
    if (not instance_exists(_bonkInstance))
    {
        __BonkError("Can only use BonkInstancePlaceList() with instances");
    }
    
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
    
    with(_bonkInstance)
    {
        var _countXY = instance_place_list(x + _dX, y + _dY, _objectXY, _list, false);
    }
    
    if (BONK_INSTANCE_XZ)
    {
        //Remove instances that don't also collide on the XZ plane
        
        var _listXZ = _listXZStatic;
        
        with(_bonkInstance.__instanceXZ)
        {
            instance_place_list(x + _dX, y + _dZ, _objectXZ, _listXZ, false);
        }
        
        var _i = _countXY-1;
        repeat(_countXY - _listStart)
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
    
    if (_groupFilter != undefined)
    {
        var _i = ds_list_size(_list)-1;
        repeat(_i+1 - _listStart)
        {
            if (_list[| _i].bonkGroup | _groupFilter)
            {
                ds_list_delete(_list, _i);
            }
            
            --_i;
        }
    }
    
    return _list;
}