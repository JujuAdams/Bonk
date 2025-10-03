// Feather disable all

/// @param xCenter
/// @param yCenter
/// @param zCenter
/// @param radius
/// @param [objectXY]
/// @param [objectXZ]

function BonkCreateSphere(_x, _y, _z, _radius, _objectXY = BonkMaskXY, _objectXZ = BonkMaskXZ)
{
    var _instance = instance_create_depth(0, 0, 0, _objectXY);
    BonkSetAsSphere(_instance,   _x, _y, _z,   _radius,   _objectXZ);
    return _instance;
}