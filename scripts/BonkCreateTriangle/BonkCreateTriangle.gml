// Feather disable all

/// @param x1
/// @param y1
/// @param z1
/// @param x2
/// @param y2
/// @param z2
/// @param x3
/// @param y3
/// @param z3
/// @param [object]

function BonkCreateTriangle(_x1, _y1, _z1, _x2, _y2, _z2, _x3, _y3, _z3, _object = BonkObject)
{
    var _instance = instance_create_depth(0, 0, 0, _object);
    BonkSetAsTriangle(_instance,   _x1, _y1, _z1,   _x2, _y2, _z2,   _x3, _y3, _z3);
    return _instance;
}