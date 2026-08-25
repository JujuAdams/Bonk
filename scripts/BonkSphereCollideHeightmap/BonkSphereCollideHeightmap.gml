// Feather disable all

/// @param sphere
/// @param heightmap
/// @param [struct]

function BonkSphereCollideHeightmap(_sphere, _heightmap, _struct = undefined)
{
    static _staticStruct = new BonkResultCollide();
    var _reaction = _struct ?? _staticStruct;
    
    var _dZ = 0;
    with(_sphere)
    {
        _dZ = _heightmap.GetHeightAt(x, y) - (z - radius);
    }
    
    if (_dZ <= 0)
    {
        _reaction.__Null();
    }
    else
    {
        with(_reaction)
        {
            //TODO - Proper push-out calculation
            
            shape = _heightmap;
            
            dX = 0;
            dY = 0;
            dZ = _dZ;
        }
    }
    
    return _reaction;
}