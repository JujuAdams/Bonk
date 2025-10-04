// Feather disable all

/// @param xCenter
/// @param yCenter
/// @param zCenter
/// @param xSize
/// @param ySize
/// @param zSize
/// @param zRotation
/// @param [objectXY]
/// @param [objectXZ]

function BonkCreateRotatedBox(_x, _y, _z, _xSize, _ySize, _zSize, _zRotation, _objectXY = BonkObjectXY, _objectXZ = BonkObjectXZ)
{
    var _instance = instance_create_depth(0, 0, 0, _objectXY);
    BonkSetAsRotatedBox(_instance,   _x, _y, _z,   _xSize, _ySize, _zSize,   _zRotation,  _objectXZ);
    return _instance;
}