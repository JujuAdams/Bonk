var _width  =  20;
var _height =  20;
var _xScale = 100;
var _yScale = 100;
var _zScale = 200;

grid = ds_grid_create(_width, _height);
repeat(50) ds_grid_add_disk(grid, irandom(_width-1), irandom(_height-1), irandom_range(3, 6), random(1));
var _min = ds_grid_get_min(grid, 0, 0, _width-1, _height-1);
ds_grid_add_region(grid, 0, 0, _width-1, _height-1, -_min);
var _max = ds_grid_get_max(grid, 0, 0, _width-1, _height-1);
ds_grid_multiply_region(grid, 0, 0, _width-1, _height-1, 1/_max);

vbuffVolume = BuildHeightmapVolume(grid, _xScale, _yScale, _zScale);