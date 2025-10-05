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
/// @param subjectInstance
/// @param dX
/// @param dY
/// @param [objectOrArray=BonkObject]
/// @param [groupFilter]
/// @param [list]

function BonkInstancePlaceList(_subjectInstance, _dX, _dY, _objectOrArray = BonkObject, _groupFilter = -1, _list = undefined)
{
    static _staticList = ds_list_create();
    
    if (not instance_exists(_subjectInstance))
    {
        __BonkError("Can only use BonkInstancePlaceList() with instances");
    }
    
    if (_list == undefined)
    {
        _list = _staticList;
        ds_list_clear(_list);
        var _listStart = 0;
    }
    else
    {
        var _listStart = ds_list_size(_list);
    }
    
    with(_subjectInstance)
    {
        if (is_array(_objectOrArray))
        {
            var _i = 0;
            repeat(array_length(_objectOrArray))
            {
                instance_place_list(x + _dX, y + _dY, _objectOrArray[_i], _list, false);
                ++_i;
            }
        }
        else
        {
            instance_place_list(x + _dX, y + _dY, _objectOrArray, _list, false);
        }
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