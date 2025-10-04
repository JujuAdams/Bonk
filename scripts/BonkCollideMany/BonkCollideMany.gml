// Feather disable all

/// @param shapeArray
/// @param subjectShape

function BonkCollideMany(_shapeArray, _subjectShape)
{
    static _returnData = [];
    array_resize(_returnData, 0);
    
    if (is_array(_shapeArray)) //We were given an array
    {
        var _i = 0;
        repeat(array_length(_shapeArray))
        {
            with(_shapeArray[_i]) //Use `with()` here to support iterating over objects
            {
                var _reaction = Collide(_subjectShape);
                if (_reaction.collision)
                {
                    array_push(_returnData, _reaction.Clone());
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
                var _reaction = Collide(_subjectShape);
                if (_reaction.collision)
                {
                    array_push(_returnData, _reaction.Clone());
                }
            }
            
            ++_i;
        }
    }
    else
    {
        with(_shapeArray[| _i]) //Use `with()` here to support iterating over objects
        {
            var _reaction = Collide(_subjectShape);
            if (_reaction.collision)
            {
                array_push(_returnData, _reaction.Clone());
            }
        }
    }
    
    return _returnData;
}