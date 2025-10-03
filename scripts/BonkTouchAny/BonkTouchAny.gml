// Feather disable all

/// @param shapeArray
/// @param subjectShape

function BonkTouchAny(_shapeArray, _subjectShape)
{
    if ((not is_array(_shapeArray)) && (not ds_exists(_shapeArray, ds_type_list)))
    {
        _shapeArray = [_shapeArray];
    }
    
    if (is_array(_shapeArray))
    {
        var _i = 0;
        repeat(array_length(_shapeArray))
        {
            with(_shapeArray[_i]) //Use `with()` here to support iterating over objects
            {
                if (Touch(_subjectShape))
                {
                    return true;
                }
            }
            
            ++_i;
        }
    }
    else if (ds_exists(_shapeArray, ds_type_list))
    {
        var _i = 0;
        repeat(ds_list_size(_shapeArray))
        {
            with(_shapeArray[| _i]) //Use `with()` here to support iterating over objects
            {
                if (Touch(_subjectShape))
                {
                    return true;
                }
            }
            
            ++_i;
        }
    }
    
    return false;
}