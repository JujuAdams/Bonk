// Feather disable all

/// Returns a ds_list containing Bonk instances that *probably* touch a line segment. Normal
/// operation would be to not provide a list in which case this function will return a statically
/// allocated list that contains all probable colliding instances.
/// 
/// However, you may choose to specify a list. Any (probable) collisions are appended to the end
/// of the list.
/// 
/// Collision checks happen in the XY plane so z-axis information is not needed by this function.
/// 
/// @param x1
/// @param y1
/// @param x2
/// @param y2
/// @param [objectOrArray=BonkObject]
/// @param [groupFilter]
/// @param [list]

function BonkCollisionLineList(_x1, _y1, _x2, _y2, _objectOrArray = BonkObject, _groupFilter = -1, _list = undefined)
{
    static _listStatic = ds_list_create();
    
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
    
    if (is_array(_objectOrArray))
    {
        var _i = 0;
        repeat(array_length(_objectOrArray))
        {
            collision_line_list(_x1, _y1, _x2, _y2, _objectOrArray[_i], false, false, _list, false);
            ++_i;
        }
    }
    else
    {
        collision_line_list(_x1, _y1, _x2, _y2, _objectOrArray, false, false, _list, false);
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