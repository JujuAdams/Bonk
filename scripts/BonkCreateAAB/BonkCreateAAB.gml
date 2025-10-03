// Feather disable all

/// @param xCenter
/// @param yCenter
/// @param zCenter
/// @param xSize
/// @param ySize
/// @param zSize
/// @param [objectXY]
/// @param [objectXZ]

function BonkCreateAAB(_x, _y, _z, _xSize, _ySize, _zSize, _objectXY = BonkMaskXY, _objectXZ = BonkMaskXZ)
{
    var _instance = instance_create_depth(0, 0, 0, _objectXY);
    BonkSetAsAAB(_instance,   _x, _y, _z,   _xSize, _ySize, _zSize,   _objectXZ);
    return _instance;
}