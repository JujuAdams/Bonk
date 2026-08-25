// Feather disable all

/// @param cylinder
/// @param heightmap
/// @param [struct]

function BonkCylinderCollideHeightmap(_cylinder, _heightmap, _struct = undefined)
{
    static _staticStruct = new BonkResultCollide();
    var _reaction = _struct ?? _staticStruct;
    
    var _dZ = 0;
    with(_cylinder)
    {
        _dZ = _heightmap.GetHeightAt(x, y) - (z - height/2);
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