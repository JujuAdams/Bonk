// Feather disable all

/// @param cellXSize
/// @param cellYSize
/// @param cellZSize
/// @param [object=BonkObject]

function BonkCreateWorld(_cellXSize, _cellYSize, _cellZSize, _object = BonkObject)
{
    var _instance = instance_create_depth(0, 0, 0, _object);
    BonkSetAsWorld(_instance,   _cellXSize, _cellYSize, _cellZSize);
    return _instance;
}