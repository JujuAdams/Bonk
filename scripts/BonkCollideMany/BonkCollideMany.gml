// Feather disable all

/// @param targetShapes
/// @param subjectShape

function BonkCollideMany(_targetShapes, _subjectShape)
{
    static _returnData = [];
    array_resize(_returnData, 0);
    
    if (is_array(_targetShapes)) //We were given an array
    {
        var _i = 0;
        repeat(array_length(_targetShapes))
        {
            with(_targetShapes[_i]) //Use `with()` here to support iterating over objects
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
    else if (ds_exists(_targetShapes, ds_type_list)) //We were given a list
    {
        var _i = 0;
        repeat(ds_list_size(_targetShapes))
        {
            with(_targetShapes[| _i]) //Use `with()` here to support iterating over objects
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
        with(_targetShapes) //Use `with()` here to support iterating over objects
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