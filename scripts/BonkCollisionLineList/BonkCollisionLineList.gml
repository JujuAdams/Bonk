// Feather disable all

/// @param x1
/// @param y1
/// @param z1
/// @param x2
/// @param y2
/// @param z2
/// @param [groupFilter]
/// @param [list]
/// @param [object=BonkObject]

function BonkCollisionLineList(_x1, _y1, _z1, _x2, _y2, _z2, _object = BonkObject, _groupFilter = -1, _list = undefined)
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
    
    collision_line_list(_x1, _y1, _x2, _y2, _object, false, false, _list, false);
    
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