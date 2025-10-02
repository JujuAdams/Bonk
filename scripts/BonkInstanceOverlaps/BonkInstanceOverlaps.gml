// Feather disable all

/// @param shape
/// @param dX
/// @param dY
/// @param dZ
/// @param [array]
/// @param [objectXY]
/// @param [objectXZ]

function BonkInstanceOverlaps(_shape, _dX, _dY, _dZ, _array = undefined, _objectXY = BonkMaskXY, _objectXZ = __BonkMaskXZ)
{
    static _staticArray = [];
    _array ??= _staticArray;
    
    if (not variable_instance_exists(_shape, "id"))
    {
        __BonkError("Can only use BonkInstanceOverlaps() with instances");
    }
    
    static _listXYStatic = ds_list_create();
    static _listXZStatic = ds_list_create();
    
    var _listXY = _listXYStatic;
    
    with(_shape)
    {
        var _countXY = instance_place_list(x + _dX, y + _dY, _objectXY, _listXY, false);
        
        //Remove self-collision
        var _index = ds_list_find_index(_listXY, id);
        if (_index >= 0)
        {
            ds_list_delete(_listXY, _index);
            --_countXY;
        }
    }
    
    if (BONK_INSTANCE_XZ)
    {
        array_resize(_array, 0);
        
        var _listXZ = _listXZStatic;
        
        with(_shape.__instanceXZ)
        {
            var _countXZ = instance_place_list(x + _dX, y + _dZ, _objectXZ, _listXZ, false);
            
            //Remove self-collision
            var _index = ds_list_find_index(_listXZ, id);
            if (_index >= 0)
            {
                ds_list_delete(_listXZ, _index);
                --_countXZ;
            }
        }
        
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