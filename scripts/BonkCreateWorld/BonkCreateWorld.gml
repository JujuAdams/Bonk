// Feather disable all

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