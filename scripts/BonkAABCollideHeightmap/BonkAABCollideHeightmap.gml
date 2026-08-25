// Feather disable all

/// @param aab
/// @param heightmap
/// @param [struct]

function BonkAABCollideHeightmap(_aab, _heightmap, _struct = undefined)
{
    static _staticStruct = new BonkResultCollide();
    var _reaction = _struct ?? _staticStruct;
    
    var _dZ = 0;
    with(_aab)
    {
        _dZ = _heightmap.GetHeightAt(x, y) - (z - zSize/2);
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