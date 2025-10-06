// Feather disable all

/// Creates an instance of the given object and sets it as a Bonk instance that can be used to
/// store Bonk structs in a spatial hash map. This is especially useful for storing static meshes
/// generated from 3D models.
/// 
/// @param cellXSize
/// @param cellYSize
/// @param cellZSize
/// @param [object=BonkObject]
/// @param [variableStruct]

function BonkCreateWorld(_cellXSize, _cellYSize, _cellZSize, _object = BonkObject, _variableStruct = undefined)
{
    static _staticVariableStruct = {};
    
    with(instance_create_depth(0, 0, 0, _object, _variableStruct ?? _staticVariableStruct))
    {
        BonkSetupWorld(_cellXSize, _cellYSize, _cellZSize);
        return self;
    }
}