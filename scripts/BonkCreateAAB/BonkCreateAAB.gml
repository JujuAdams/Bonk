// Feather disable all

/// Creates an instance of the given object and sets it as a Bonk AAB instance. Please see
/// `BonkSetupAAB()` for more details on what variables and properties are available on the created
/// instance. Bonk instances share the same basic behaviour and an details can be found in the
/// `Bonk Instance Details` Note asset.
/// 
/// @param xCenter
/// @param yCenter
/// @param zCenter
/// @param xSize
/// @param ySize
/// @param zSize
/// @param [object=BonkObject]
/// @param [variableStruct]
/// @param [groupVector=BONK_DEFAULT_GROUP]

function BonkCreateAAB(_x, _y, _z, _xSize, _ySize, _zSize, _object = BonkObject, _variableStruct = undefined, _groupVector = BONK_DEFAULT_GROUP)
{
    static _staticVariableStruct = {};
    
    with(instance_create_depth(0, 0, 0, _object, _variableStruct ?? _staticVariableStruct))
    {
        BonkSetupAAB(_x, _y, _z,   _xSize, _ySize, _zSize,   _groupVector);
        return self;
    }
}