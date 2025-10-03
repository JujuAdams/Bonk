// Feather disable all

/// @param xCenter
/// @param yCenter
/// @param zCenter
/// @param height
/// @param radius
/// @param [objectXY]
/// @param [objectXZ]

function BonkCreateCapsule(_x, _y, _z, _height, _radius, _objectXY = BonkMaskXY, _objectXZ = BonkMaskXZ)
{
    var _instance = instance_create_depth(0, 0, 0, _objectXY);
    BonkSetAsCapsule(_instance,   _x, _y, _z,   _height, _radius,   _objectXZ);
    return _instance;
}