// Feather disable all

/// Creates an instance of the given object and sets it as a Bonk triangle instance. Please see
/// `BonkSetupTriangle()` for more details on what variables and properties are available on the
/// created instance. Bonk instances share the same basic behaviour and an details can be found in
/// the `Bonk Instance Details` Note asset.
/// 
/// @param x1
/// @param y1
/// @param z1
/// @param x2
/// @param y2
/// @param z2
/// @param x3
/// @param y3
/// @param z3
/// @param [object=BonkObject]
/// @param [variableStruct]
/// @param [groupVector=BONK_DEFAULT_GROUP]

function BonkCreateTriangle(_x1, _y1, _z1, _x2, _y2, _z2, _x3, _y3, _z3, _object = BonkObject, _variableStruct = undefined, _groupVector = BONK_DEFAULT_GROUP)
{
    static _staticVariableStruct = {};
    
    with(instance_create_depth(0, 0, 0, _object, _variableStruct ?? _staticVariableStruct))
    {
        BonkSetupTriangle(_x1, _y1, _z1,   _x2, _y2, _z2,   _x3, _y3, _z3,   _groupVector);
        return self;
    }
}