var _width  =   3;
var _height =   3;
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

shape = new BonkStructHeightmap(function(_x, _y)
{
    var _grid = grid;
    
    var _xFrac = frac(_x);
    var _yFrac = frac(_y);
    _x = floor(_x);
    _y = floor(_y);
    
    var _x2 = min(_x+1, ds_grid_width(_grid)-1);
    var _y2 = min(_y+1, ds_grid_width(_grid)-1);
    
    return lerp(lerp(_grid[# _x, _y ], _grid[# _x2, _y ], _xFrac),
                lerp(_grid[# _x, _y2], _grid[# _x2, _y2], _xFrac), _yFrac);
},
_width, _height, 0, 1, 0, 0, 0, _xScale, _yScale, _zScale)

vbuffVolume = BuildHeightmapVolume(grid, _xScale, _yScale, _zScale);