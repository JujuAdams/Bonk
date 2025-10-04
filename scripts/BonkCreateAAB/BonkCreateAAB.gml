// Feather disable all

/// @param xCenter
/// @param yCenter
/// @param zCenter
/// @param xSize
/// @param ySize
/// @param zSize
/// @param [object=BonkObject]
/// @param [groupVector=BONK_DEFAULT_GROUP]

function BonkCreateAAB(_x, _y, _z, _xSize, _ySize, _zSize, _object = BonkObject, _groupVector = BONK_DEFAULT_GROUP)
{
    with(instance_create_depth(0, 0, 0, _object))
    {
        BonkSetAsAAB(_x, _y, _z,   _xSize, _ySize, _zSize,   _groupVector);
        return self;
    }
}