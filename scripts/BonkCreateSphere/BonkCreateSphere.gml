// Feather disable all

/// @param xCenter
/// @param yCenter
/// @param zCenter
/// @param radius
/// @param [object=BonkObject]
/// @param [groupVector=BONK_DEFAULT_GROUP]

function BonkCreateSphere(_x, _y, _z, _radius, _object = BonkObject, _groupVector = BONK_DEFAULT_GROUP)
{
    with(instance_create_depth(0, 0, 0, _object))
    {
        BonkSetAsSphere(_x, _y, _z,   _radius,   _groupVector);
        return self;
    }
}