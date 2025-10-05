// Feather disable all

/// Creates an instance of the given object and sets it as a Bonk cylinder instance.
/// 
/// @param xCenter
/// @param yCenter
/// @param zCenter
/// @param height
/// @param radius
/// @param [object=BonkObject]
/// @param [groupVector=BONK_DEFAULT_GROUP]

function BonkCreateCylinder(_x, _y, _z, _height, _radius, _object = BonkObject, _groupVector = BONK_DEFAULT_GROUP)
{
    with(instance_create_depth(0, 0, 0, _object))
    {
        BonkSetupCylinder(_x, _y, _z,   _height, _radius,   _groupVector);
        return self;
    }
}