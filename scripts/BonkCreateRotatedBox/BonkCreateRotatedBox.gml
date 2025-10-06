// Feather disable all

/// Creates an instance of the given object and sets it as a Bonk rotated box instance.
/// 
/// @param xCenter
/// @param yCenter
/// @param zCenter
/// @param xSize
/// @param ySize
/// @param zSize
/// @param zRotation
/// @param [object=BonkObject]
/// @param [variableStruct]
/// @param [groupVector=BONK_DEFAULT_GROUP]

function BonkCreateRotatedBox(_x, _y, _z, _xSize, _ySize, _zSize, _zRotation, _object = BonkObject, _variableStruct = undefined, _groupVector = BONK_DEFAULT_GROUP)
{
    static _staticVariableStruct = {};
    
    with(instance_create_depth(0, 0, 0, _object, _variableStruct ?? _staticVariableStruct))
    {
        BonkSetupRotatedBox(_x, _y, _z,   _xSize, _ySize, _zSize,   _zRotation,   _groupVector);
        return self;
    }
}