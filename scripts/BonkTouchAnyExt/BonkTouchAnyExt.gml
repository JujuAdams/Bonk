// Feather disable all

/// Returns `true` if the subject shape touches any of the target shapes. If any of the shapes
/// being tested are Bonk worlds then this function will also test for collisions with structs
/// stored inside the Bonk world.
/// 
/// The `targetShapes` parameter can be an array, a list, a Bonk struct/instance, or an object used
/// to create Bonk instances. If you provide an array or list then elements in the array/list
/// should be either a Bonk struct/instance or an object.
/// 
/// You may also filter what shapes you do and don't want to test for by setting the optional
/// `groupFilter` parameter. Please see `BonkFilter()` for more information.
/// 
/// @param subjectShape
/// @param targetShapes
/// @param [groupFilter]

function BonkTouchAnyExt(_subjectShape, _targetShapes, _groupFilter = -1)
{
    if (is_array(_targetShapes)) //We were given an array
    {
        var _i = 0;
        repeat(array_length(_targetShapes))
        {
            with(_targetShapes[_i]) //Use `with()` here to support iterating over objects
            {
                if (Touch(_subjectShape, _groupFilter))
                {
                    return true;
                }
            }
            
            ++_i;
        }
    }
    else if (is_handle(_targetShapes) && ds_exists(_targetShapes, ds_type_list)) //We were given a list
    {
        var _i = 0;
        repeat(ds_list_size(_targetShapes))
        {
            with(_targetShapes[| _i]) //Use `with()` here to support iterating over objects
            {
                if (Touch(_subjectShape, _groupFilter))
                {
                    return true;
                }
            }
            
            ++_i;
        }
    }
    else
    {
        with(_targetShapes) //Use `with()` here to support iterating over objects
        {
            if (Touch(_subjectShape, _groupFilter))
            {
                return true;
            }
        }
    }
    
    return false;
}