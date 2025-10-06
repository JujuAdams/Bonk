// Feather disable all

/// Returns an array of hit data (`BonkResultHit`) that the line segment touches by iterating over
/// the provided target shapes. If any of the shapes being tested are Bonk worlds then this
/// function will also test for collisions with structs stored inside the Bonk world.
/// 
/// This function will return a statically allocated array. Calling this function multiple times
/// will reuse the same array.
/// 
/// The `targetShapes` parameter can be an array, a list, a Bonk struct/instance, or an object used
/// to create Bonk instances. If you provide an array or list then elements in the array/list
/// should be either a Bonk struct/instance or an object.
/// 
/// You may also filter what shapes you do and don't want to test for by setting the optional
/// `groupFilter` parameter. Please see `BonkFilter()` for more information.
/// 
/// @param x1
/// @param y1
/// @param z1
/// @param x2
/// @param y2
/// @param z2
/// @param targetShapes
/// @param [groupFilter]

function BonkLineHitManyExt(_x1, _y1, _z1, _x2, _y2, _z2, _targetShapes, _groupFilter = -1)
{
    static _returnData = [];
    array_resize(_returnData, 0);
    
    var _hit = new BonkResultCollide();
    
    if (is_array(_targetShapes))
    {
        var _i = 0;
        repeat(array_length(_targetShapes))
        {
            with(_targetShapes[_i]) //Use `with()` here to support iterating over objects
            {
                if (LineHit(_x1, _y1, _z1, _x2, _y2, _z2, _groupFilter, _hit).shape != undefined)
                {
                    array_push(_returnData, _hit);
                    _hit = new BonkResultCollide();
                }
            }
            
            ++_i;
        }
    }
    else if (ds_exists(_targetShapes, ds_type_list))
    {
        var _i = 0;
        repeat(ds_list_size(_targetShapes)) //Use `with()` here to support iterating over objects
        {
            with(_targetShapes[| _i])
            {
                if (LineHit(_x1, _y1, _z1, _x2, _y2, _z2, _groupFilter, _hit).shape != undefined)
                {
                    array_push(_returnData, _hit);
                    _hit = new BonkResultCollide();
                }
            }
            
            ++_i;
        }
    }
    else
    {
        with(_targetShapes) //Use `with()` here to support iterating over objects
        {
            if (LineHit(_x1, _y1, _z1, _x2, _y2, _z2, _groupFilter, _hit).shape != undefined)
            {
                array_push(_returnData, _hit);
                _hit = new BonkResultCollide();
            }
        }
    }
    
    return _returnData;
}