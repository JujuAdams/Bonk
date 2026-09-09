// Feather disable all

/// @param function    Function to call to retrieve the height at a given position. The position contain a fractional component
/// @param x           Position of the top-left corner
/// @param y           Position of the top-left corner
/// @param z           Position of the top-left corner
/// @param cellWidth   Number of cells in the x axis
/// @param cellHeight  Number of cells in the y axis
/// @param xScale      Scaling factor to apply (this is analogous to the width of a single cell in the x-axis)
/// @param yScale      Scaling factor to apply (this is analogous to the height of a single cell in the y-axis)
/// @param zScale      Scaling factor to apply
/// @param [tesselation=simple]
/// @param [groupVector=BONK_DEFAULT_GROUP]

function BonkStructHeightmap(_function, _x, _y, _z, _cellWidth, _cellHeight, _xScale, _yScale, _zScale, _tesselation = BONK_TESSELATE_SIMPLE, _groupVector = BONK_DEFAULT_GROUP) : __BonkClassShared(_groupVector) constructor
{
    __BonkCommonHeightmap(_function, _x, _y, _z, _cellWidth, _cellHeight, _xScale, _yScale, _zScale, _tesselation);
    UpdateTriangles();
    
    
    
    static __SetPositionFree = function(_x = x, _y = y, _z = z)
    {
        x = _x;
        y = _y;
        z = _z;
        
        return self;
    }
    
    static __SetPositionInWorld = function(_x = x, _y = y, _z = z)
    {
        __bonkWorld.__MoveShape(_x - x, _y - y, _z - z, self);
        
        x = _x;
        y = _y;
        z = _z;
        
        return self;
    }
    
    SetPosition = __SetPositionFree;
    
    static SetHeightmapSize = function(_cellWidth = cellWidth, _cellHeight = cellHeight)
    {
        cellWidth  = _cellWidth;
        cellHeight = _cellHeight;
        
        UpdateTriangles();
    }
    
    static SetScale = function(_xScale = xScale, _yScale = yScale, _zScale = zScale)
    {
        xScale = _xScale;
        yScale = _yScale;
        zScale = _zScale;
        
        UpdateTriangles();
    }
}