function CreateHeightmap()
{
    cellCountX =   5;
    cellCountY =   5;
    xScale     = 100;
    yScale     = 100;
    zScale     = 100;
    
    var _vertexHeightCountX = cellCountX + 1;
    var _vertexHeightCountY = cellCountY + 1;
    vertexHeightGrid = ds_grid_create(_vertexHeightCountX, _vertexHeightCountY);
    //repeat(50) ds_grid_add_disk(vertexHeightGrid, irandom(_vertexHeightCountX-1), irandom(_vertexHeightCountY-1), irandom_range(3, 6), random(1));
    
    var _y = 0;
    repeat(ds_grid_height(vertexHeightGrid))
    {
        var _x = 0;
        repeat(ds_grid_width(vertexHeightGrid))
        {
            vertexHeightGrid[# _x, _y] = random(1);
            ++_x;
        }
        
        ++_y;
    }
    
    var _min = ds_grid_get_min(vertexHeightGrid, 0, 0, _vertexHeightCountX, _vertexHeightCountY);
    ds_grid_add_region(vertexHeightGrid, 0, 0, _vertexHeightCountX, _vertexHeightCountY, -_min);
    var _max = ds_grid_get_max(vertexHeightGrid, 0, 0, _vertexHeightCountX, _vertexHeightCountY);
    if (_max != 0) ds_grid_multiply_region(vertexHeightGrid, 0, 0, _vertexHeightCountX, _vertexHeightCountY, 1/_max);
    
    funcGetHeight = function(_x, _y)
    {
        var _grid = vertexHeightGrid;
        
        if ((_x < 0) || (_y < 0) || (_x > ds_grid_width(_grid)-1) || (_y > ds_grid_height(_grid)-1))
        {
            return undefined;
        }
        
        var _xFrac = frac(_x);
        var _yFrac = frac(_y);
        
        _x = floor(_x);
        _y = floor(_y);
        
        if (_xFrac == 0)
        {
            if (_yFrac == 0)
            {
                return _grid[# _x, _y];
            }
            else
            {
                return lerp(_grid[# _x, _y], _grid[# _x, _y+1], _yFrac);
            }
        }
        else
        {
            if (_yFrac == 0)
            {
                return lerp(_grid[# _x, _y], _grid[# _x+1, _y], _xFrac);
            }
            else
            {
                return lerp(lerp(_grid[# _x, _y  ], _grid[# _x+1, _y  ], _xFrac),
                            lerp(_grid[# _x, _y+1], _grid[# _x+1, _y+1], _xFrac), _yFrac);
            }
        }
    }
}