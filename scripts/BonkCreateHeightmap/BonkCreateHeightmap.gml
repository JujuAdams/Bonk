// Feather disable all

/// Creates an instance of the given object and sets it as a Bonk triangle instance. Please see
/// `BonkSetupTriangle()` for more details on what variables and properties are available on the
/// created instance. Bonk instances share the same basic behaviour and an details can be found in
/// the `Bonk Instance Details` Note asset.
/// 
/// @param function    Function to call to retrieve the height at a given position. The position contain a fractional component
/// @param x           Position of the top-left corner
/// @param y           Position of the top-left corner
/// @param z           Position of the top-left corner
/// @param cellWidth   Number of cells in the x axis
/// @param cellHeight  Number of cells in the y axis
/// @param xScale      Scaling factor to apply (this is analogous to the width of a single cell in the x-axis)
/// @param yScale      Scaling factor to apply (this is analogous to the height of a single cell in the y-axis)
/// @param zScale      Scaling factor to apply
/// @param [object=BonkObject]
/// @param [variableStruct]
/// @param [groupVector=BONK_DEFAULT_GROUP]

function BonkCreateHeightmap(_function, _x, _y, _z, _cellWidth, _cellHeight, _xScale, _yScale, _zScale, _object = BonkObject, _variableStruct = undefined, _groupVector = BONK_DEFAULT_GROUP)
{
    static _staticVariableStruct = {};
    
    with(instance_create_depth(0, 0, 0, _object, _variableStruct ?? _staticVariableStruct))
    {
        BonkSetupHeightmap(_function,   _x, _y, _z,   _cellWidth, _cellHeight,   _xScale, _yScale, _zScale,   _groupVector);
        return self;
    }
}