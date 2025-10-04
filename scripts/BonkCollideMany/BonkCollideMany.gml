// Feather disable all

/// 
/// The `targetShapes` parameter can be an array, a list, a Bonk struct/instance, or an object used
/// to create Bonk instances. If you provide an array or list then elements in the array/list
/// should be either a Bonk struct/instance or an object.
/// 
/// @param subjectShape
/// @param targetShapes
/// @param [groupFilter]

function BonkCollideMany(_subjectShape, _targetShapes, _groupFilter = -1)
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
                var _reaction = Collide(_subjectShape, _groupFilter);
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
                var _reaction = Collide(_subjectShape, _groupFilter);
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
            var _reaction = Collide(_subjectShape, _groupFilter);
            if (_reaction.collision)
            {
                array_push(_returnData, _reaction.Clone());
            }
        }
    }
    
    return _returnData;
}