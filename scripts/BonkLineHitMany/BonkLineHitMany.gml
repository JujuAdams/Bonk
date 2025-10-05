// Feather disable all

/// @param x1
/// @param y1
/// @param z1
/// @param x2
/// @param y2
/// @param z2
/// @param [objectOrArray=BonkObject]
/// @param [groupFilter]

function BonkLineHitMany(_x1, _y1, _z1, _x2, _y2, _z2, _objectOrArray = BonkObject, _groupFilter = -1)
{
    return BonkLineHitManyExt(_x1, _y1, _z1, _x2, _y2, _z2, BonkCollisionLineList(_x1, _y1, _x2, _y2, _objectOrArray), _groupFilter);
}