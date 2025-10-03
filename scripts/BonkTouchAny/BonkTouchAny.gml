// Feather disable all

/// @param shapeArray
/// @param subjectShape

function BonkTouchAny(_shapeArray, _subjectShape)
{
    if (is_array(_shapeArray)) //We were given an array
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
    else if (ds_exists(_shapeArray, ds_type_list)) //We were given a list
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
    else
    {
        with(_shapeArray) //Use `with()` here to support iterating over objects
        {
            if (Touch(_subjectShape))
            {
                return true;
            }
        }
    }
    
    return false;
}