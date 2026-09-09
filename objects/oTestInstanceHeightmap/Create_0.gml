var _width  =   5;
var _height =   5;
var _xScale = 100;
var _yScale = 100;
var _zScale = 100;

grid = ds_grid_create(_width, _height);
//repeat(50) ds_grid_add_disk(grid, irandom(_width-1), irandom(_height-1), irandom_range(3, 6), random(1));

var _y = 0;
repeat(ds_grid_height(grid))
{
    var _x = 0;
    repeat(ds_grid_width(grid))
    {
        grid[# _x, _y] = random(1);
        ++_x;
    }
    
    ++_y;
}

var _min = ds_grid_get_min(grid, 0, 0, _width-1, _height-1);
ds_grid_add_region(grid, 0, 0, _width-1, _height-1, -_min);
var _max = ds_grid_get_max(grid, 0, 0, _width-1, _height-1);
if (_max != 0) ds_grid_multiply_region(grid, 0, 0, _width-1, _height-1, 1/_max);

var _function = function(_x, _y)
{
    var _grid = grid;
    
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

BonkSetupHeightmap(_function, x, y, 0, _width-1, _height-1, _xScale, _yScale, _zScale);
//vbuffVolume = BuildHeightmapVolume(grid, _xScale, _yScale, _zScale);