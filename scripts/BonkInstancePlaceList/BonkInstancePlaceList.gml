// Feather disable all

/// Returns a ds_list containing Bonk instances that *probably* touch the provided Bonk instance.
/// Normal operation would be to not provide a list in which case this function will return a
/// statically allocated list that contains all probable colliding instances.
/// 
/// However, you may choose to specify a list. Any (probable) collisions are appended to the end
/// of the list.
/// 
/// Collision checks happen in the XY plane. You specify a `dX` and `dY` value to collision the
/// subject Bonk instance in a different position to where its `x` and `y` position would otherwise
/// indicate.
/// 
/// @param bonkInstance
/// @param dX
/// @param dY
/// @param [object=BonkObject]
/// @param [groupFilter]
/// @param [list]

function BonkInstancePlaceList(_bonkInstance, _dX, _dY, _object = BonkObject, _groupFilter = -1, _list = undefined)
{
    static _listStatic = ds_list_create();
    
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