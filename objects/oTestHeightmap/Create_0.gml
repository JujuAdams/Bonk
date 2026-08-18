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
if (_max != 0) ds_grid_multiply_region(grid, 0, 0, _width-1, _height-1, 1/_max);

vbuffVolume = BuildHeightmapVolume(grid, _xScale, _yScale, _zScale);

//var _funcTriangle = function(_vbuff,   _x1, _y1, _z1,   _x2, _y2, _z2,   _x3, _y3, _z3)
//{
//    var _dx12 = _x2 - _x1;
//    var _dy12 = _y2 - _y1;
//    var _dz12 = _z2 - _z1;
//    
//    var _dx13 = _x3 - _x1;
//    var _dy13 = _y3 - _y1;
//    var _dz13 = _z3 - _z1;
//    
//    var _normalX = -(_dz12*_dy13 - _dy12*_dz13);
//    var _normalY = -(_dx12*_dz13 - _dz12*_dx13);
//    var _normalZ = -(_dy12*_dx13 - _dx12*_dy13);
//    
//    vertex_position_3d(_vbuff, _x1, _y1, _z1); vertex_normal(_vbuff, _normalX, _normalY, _normalZ);
//    vertex_position_3d(_vbuff, _x2, _y2, _z2); vertex_normal(_vbuff, _normalX, _normalY, _normalZ);
//    vertex_position_3d(_vbuff, _x3, _y3, _z3); vertex_normal(_vbuff, _normalX, _normalY, _normalZ);
//}
//
//vbuffVolume = vertex_create_buffer();
//vertex_begin(vbuffVolume, GetHeightmapVolumeVertexFormat());
//_funcTriangle(vbuffVolume,   0,   0,  20,   100, 0, 0,     0, 100,  0);
//_funcTriangle(vbuffVolume,   0, 100,  0,   100, 0, 0,   100, 100,  20);
//vertex_end(vbuffVolume);