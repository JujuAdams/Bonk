// Feather disable all

/// @param xCenter
/// @param yCenter
/// @param zCenter
/// @param xSize
/// @param ySize
/// @param zSize
/// @param zRotation
/// @param [object=BonkObject]
/// @param [groupVector=BONK_DEFAULT_GROUP]

function BonkCreateRotatedBox(_x, _y, _z, _xSize, _ySize, _zSize, _zRotation, _object = BonkObject, _groupVector = BONK_DEFAULT_GROUP)
{
    var _instance = instance_create_depth(0, 0, 0, _object);
    BonkSetAsRotatedBox(_instance,   _x, _y, _z,   _xSize, _ySize, _zSize,   _zRotation,   _groupVector);
    return _instance;
}