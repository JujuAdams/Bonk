// Feather disable all

/// @param bonkInstance
/// @param dX
/// @param dY
/// @param dZ
/// @param [object=BonkObject]
/// @param [groupFilter]
/// @param [list]

function BonkInstancePlaceList(_bonkInstance, _dX, _dY, _dZ, _object = BonkObject, _groupFilter = -1, _list = undefined)
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
    
    if (_groupFilter >= 0)
    {
        var _i = ds_list_size(_list)-1;
        repeat(_i+1 - _listStart)
        {
            if (not _list[| _i].FilterTest(_groupFilter))
            {
                ds_list_delete(_list, _i);
            }
            
            --_i;
        }
    }
    
    return _list;
}