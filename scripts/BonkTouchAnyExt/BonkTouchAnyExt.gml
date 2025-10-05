// Feather disable all

/// This function returns `true` if the subject shape intersects with one or more target shapes.
/// The subject shape can be either a Bonk struct or a Bonk instance.
/// 
/// The `targetShapes` parameter can be an array, a list, a Bonk struct/instance, or an object used
/// to create Bonk instances. If you provide an array or list then elements in the array/list
/// should be either a Bonk struct/instance or an object.
/// 
/// That's quite a lot to take in so here are some examples of use:
/// 
/// `BonkTouchAnyExt(shape, BonkObject);`
///   Will check if the subject shape touches any instance of the `BonkObject` object or are
///   instances of objects that inherit from `BonkObject`. The subject shape can be a Bonk struct
///   or Bonk instance.
/// 
/// `BonkTouchAnyExt(shape, [oColliderWater, oColliderLava]);`
///   Will check if the subject shape touches any instance of `oColliderWater` or `oColliderLava`
///   or are instances of objects that inherit from `oColliderWater` or `oColliderLava`. The
///   subject shape can be a Bonk struct or Bonk instance.
/// 
/// `BonkTouchAnyExt(shape, triggerArray);`
///   Will check if the subject shape touches any shape stored in `triggerArray`. The shapes in the
///   array can be structs, instances, or objects.
/// 
/// `BonkTouchAnyExt(shapeInstance, BonkInstancePlaceList(shapeInstance, 0, 0, 0));`
///   Will check if the subject shape touches any instance found by the broad phase function
///   `BonkInstancePlaceList()`. The subject shape must be a Bonk instance in this siutation
///   because `BonkInstancePlaceList()` only works with Bonk instances.
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
    else if (ds_exists(_targetShapes, ds_type_list)) //We were given a list
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