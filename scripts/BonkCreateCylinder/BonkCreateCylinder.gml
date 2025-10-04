// Feather disable all

/// @param xCenter
/// @param yCenter
/// @param zCenter
/// @param height
/// @param radius
/// @param [object]

function BonkCreateCylinder(_x, _y, _z, _height, _radius, _object = BonkObject)
{
    var _instance = instance_create_depth(0, 0, 0, _object);
    BonkSetAsCylinder(_instance,   _x, _y, _z,  _height, _radius);
    return _instance;
}