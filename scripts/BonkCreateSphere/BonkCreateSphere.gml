// Feather disable all

/// @param xCenter
/// @param yCenter
/// @param zCenter
/// @param radius
/// @param [object]

function BonkCreateSphere(_x, _y, _z, _radius, _object = BonkObject)
{
    var _instance = instance_create_depth(0, 0, 0, _object);
    BonkSetAsSphere(_instance,   _x, _y, _z,   _radius);
    return _instance;
}