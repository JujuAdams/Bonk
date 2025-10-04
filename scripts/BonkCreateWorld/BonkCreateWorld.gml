// Feather disable all

/// Creates an instance of the given object and sets it as a Bonk instance that can be used to
/// stored Bonk structs in a spatial hash map. This is useful for storing static meshes generated
/// from 3D models.
/// 
/// @param cellXSize
/// @param cellYSize
/// @param cellZSize
/// @param [object=BonkObject]

function BonkCreateWorld(_cellXSize, _cellYSize, _cellZSize, _object = BonkObject)
{
    with(instance_create_depth(0, 0, 0, _object))
    {
        BonkSetAsWorld(_cellXSize, _cellYSize, _cellZSize);
        return self;
    }
}