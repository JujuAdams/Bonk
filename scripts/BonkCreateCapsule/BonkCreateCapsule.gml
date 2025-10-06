// Feather disable all

/// Creates an instance of the given object and sets it as a Bonk capsule instance. Please see
/// `BonkSetupCapsule()` for more details on what variables and properties are available on the
/// created instance. Bonk instances share the same basic behaviour and an details can be found in
/// the `Bonk Instance Details` Note asset.
/// 
/// @param xCenter
/// @param yCenter
/// @param zCenter
/// @param height
/// @param radius
/// @param [object=BonkObject]
/// @param [variableStruct]
/// @param [groupVector=BONK_DEFAULT_GROUP]

function BonkCreateCapsule(_x, _y, _z, _height, _radius, _object = BonkObject, _variableStruct = undefined, _groupVector = BONK_DEFAULT_GROUP)
{
    static _staticVariableStruct = {};
    
    with(instance_create_depth(0, 0, 0, _object, _variableStruct ?? _staticVariableStruct))
    {
        BonkSetupCapsule(_x, _y, _z,   _height, _radius,   _groupVector);
        return self;
    }
}