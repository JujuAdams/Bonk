// Feather disable all

/// @param bonkInstance
/// @param dX
/// @param dY
/// @param dZ
/// @param [groupFilter]
/// @param [list]
/// @param [object]

function BonkInstancePlaceList(_bonkInstance, _dX, _dY, _dZ, _groupFilter = undefined, _list = undefined, _object = BonkObject)
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
        instance_place_list(x + _dX, y + _dY, _object, _list, false);
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