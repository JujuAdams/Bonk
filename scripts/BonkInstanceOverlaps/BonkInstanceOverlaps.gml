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
    
    static _listXY = ds_list_create();
    static _listXZ = ds_list_create();
    
    var _countXY = instance_place_list(_shape.x + _dX, _shape.y + _dY, _objectXY, _listXY, false);
    
    var _index = ds_list_find_index(_listXY, _shape.id);
    if (_index >= 0)
    {
        ds_list_delete(_listXY, _index);
        --_countXY;
    }
    
    if (BONK_INSTANCE_XZ)
    {
        array_resize(_array, 0);
        
        instance_place_list(_shape.x + _dX, _shape.z + _dZ, _objectXZ, _listXZ, false);
        
        var _i = 0;
        repeat(_countXY)
        {
            var _otherShape = _listXY[| _i];
            
            var _index = ds_list_find_index(_listXZ, _otherShape);
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