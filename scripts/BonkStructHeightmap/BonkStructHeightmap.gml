// Feather disable all

/// @param function    Function to call to retrieve the height at a given position. The position contain a fractional component
/// @param cellWidth   Number of cells in the x axis
/// @param cellHeight  Number of cells in the y axis
/// @param cellMinZ    Minimum cell z
/// @param cellMaxZ    Maximum cell z
/// @param x           Position of the top-left corner
/// @param y           Position of the top-left corner
/// @param z           Position of the top-left corner
/// @param xScale      Scaling factor to apply (this is analogous to the width of a single cell in the x-axis)
/// @param yScale      Scaling factor to apply (this is analogous to the height of a single cell in the y-axis)
/// @param zScale      Scaling factor to apply
/// @param [groupVector=BONK_DEFAULT_GROUP]

//Set up statics
with(static_get(BonkStructHeightmap))
{
    __BonkCommonHeightmap();
}

function BonkStructHeightmap(_function, _cellWidth, _cellHeight, _cellMinZ, _cellMaxZ, _x, _y, _z, _xScale, _yScale, _zScale, _groupVector = BONK_DEFAULT_GROUP) : __BonkClassShared(_groupVector) constructor
{
    heightFunction = _function;
    
    cellWidth  = _cellWidth;
    cellHeight = _cellHeight;
    cellMinZ   = _cellMinZ;
    cellMaxZ   = _cellMaxZ;
    
    x = _x;
    y = _y;
    z = _z;
    
    xScale = _xScale;
    yScale = _yScale;
    zScale = _zScale;
    
    clampPosition = false;
    
    
    
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
    
    static GetHeightAt = function(_x, _y)
    {
        if (clampPosition)
        {
            var _xCell = clamp((_x - x) / xScale, 0, cellWidth-1);
            var _yCell = clamp((_y - y) / yScale, 0, cellHeight-1);
        }
        else
        {
            var _xCell = (_x - x) / xScale;
            if ((_xCell < 0) || (_xCell >= cellWidth))
            {
                return -infinity;
            }
            
            var _yCell = (_y - y) / yScale;
            if ((_yCell < 0) || (_yCell >= cellHeight))
            {
                return -infinity;
            }
        }
        
        return zScale*heightFunction(_xCell, _yCell);
    }
    
    static GetNormalAt = function(_x, _y)
    {
        static _result = {
            x: 0,
            y: 0,
            z: 0,
        };
        
        var _dx12 = 0.01;
        var _dy13 = 0.01;
        
        var _heightC = GetHeight(_x,         _y        );
        var _heightR = GetHeight(_x + _dx12, _y        );
        var _heightB = GetHeight(_x,         _y + _dy13);
        
        with(_result)
        {
            if (is_infinity(_heightC) || is_infinity(_heightR) || is_infinity(_heightB))
            {
                x = 0;
                y = 0;
                z = 1;
            }
            else
            {
                var _dz12 = _heightR - _heightC;
                var _dz13 = _heightB - _heightC;
                
                x =  _dz12*_dy13;
                y =  _dx12*_dz13;
                z = -_dx12*_dy13;
                
                return self;
            }
        }
    }
    
    static GetAABB = function()
    {
        return {
            xMin: x,
            yMin: y + cellMinZ*zScale,
            zMin: z + cellMinZ*zScale,
            xMax: x + cellWidth*xScale,
            yMax: y + cellHeight*yScale,
            zMax: z + cellMaxZ*zScale,
        };
    }
    
    static DebugDraw = function(_color = undefined, _wireframe = undefined)
    {
        __BONK_VERIFY_UGG
        
        var _subdivision = 6;
        
        var _x = x;
        var _y = y;
        var _z = z;
        
        var _xScale = xScale;
        var _yScale = yScale;
        var _zScale = zScale;
        
        var _heightFunction = heightFunction;
        
        var _yWorld = _y;
        var _yCell = 0;
        repeat(_subdivision*(cellHeight-1) + 1)
        {
            var _xWorld = _x;
            var _xCell = 0;
            repeat(_subdivision*(cellWidth-1) + 1)
            {
                var _height = _z + _zScale*_heightFunction(_xCell, _yCell);
                
                UggPoint(_xWorld, _yWorld, _height, _color, _wireframe);
                
                _xWorld += _xScale/_subdivision;
                _xCell += 1/_subdivision;
            }
            
            _yWorld += _yScale/_subdivision;
            _yCell += 1/_subdivision;
        }
    }
}