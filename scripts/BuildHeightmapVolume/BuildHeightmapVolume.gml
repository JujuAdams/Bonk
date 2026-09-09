/// @param grid
/// @param xScale
/// @param yScale
/// @param zScale

function BuildHeightmapVolume(_grid, _xScale, _yScale, _zScale)
{
    var _width  = ds_grid_width(_grid);
    var _height = ds_grid_width(_grid);
    
    if ((_width < 2) || (_height < 2))
    {
        show_error($"Heightmap grid must be at least 2x2 (was {_width} x {_height})", true);
    }
    
    var _funcTriangle = function(_vbuff,   _x1, _y1, _z1,   _x2, _y2, _z2,   _x3, _y3, _z3)
    {
        var _dx12 = _x2 - _x1;
        var _dy12 = _y2 - _y1;
        var _dz12 = _z2 - _z1;
        
        var _dx13 = _x3 - _x1;
        var _dy13 = _y3 - _y1;
        var _dz13 = _z3 - _z1;
        
        var _normalX = -(_dz12*_dy13 - _dy12*_dz13);
        var _normalY = -(_dx12*_dz13 - _dz12*_dx13);
        var _normalZ = -(_dy12*_dx13 - _dx12*_dy13);
        
        vertex_position_3d(_vbuff, _x1, _y1, _z1); vertex_normal(_vbuff, _normalX, _normalY, _normalZ);
        vertex_position_3d(_vbuff, _x2, _y2, _z2); vertex_normal(_vbuff, _normalX, _normalY, _normalZ);
        vertex_position_3d(_vbuff, _x3, _y3, _z3); vertex_normal(_vbuff, _normalX, _normalY, _normalZ);
    }
    
    var _vbuff = vertex_create_buffer();
    vertex_begin(_vbuff, GetHeightmapVolumeVertexFormat());
    
    var _y = 0;
    repeat(_height-1)
    {
        var _x = 0;
        repeat(_width-1)
        {
            var _xl = _xScale*_x;
            var _yt = _yScale*_y;
            //var _xm = _xl + 0.5*_xScale;
            //var _ym = _yt + 0.5*_yScale;
            var _xr = _xl + _xScale;
            var _yb = _yt + _yScale;
            
            var _z1 = _zScale*_grid[# _x,   _y  ];
            var _z2 = _zScale*_grid[# _x+1, _y  ];
            var _z3 = _zScale*_grid[# _x,   _y+1];
            var _z4 = _zScale*_grid[# _x+1, _y+1];
            //var _zm = 0.25*(_z1 + _z2 + _z3 + _z4);
            
            _funcTriangle(_vbuff,   _xl, _yt, _z1,   _xr, _yt, _z2,   _xl, _yb, _z3);
            _funcTriangle(_vbuff,   _xl, _yb, _z3,   _xr, _yt, _z2,   _xr, _yb, _z4);
            
            //_funcTriangle(_vbuff,   _xl, _yt, _z1,   _xr, _yt, _z2,   _xm, _ym, _zm);
            //_funcTriangle(_vbuff,   _xr, _yt, _z2,   _xr, _yb, _z4,   _xm, _ym, _zm);
            //_funcTriangle(_vbuff,   _xr, _yb, _z4,   _xl, _yb, _z3,   _xm, _ym, _zm);
            //_funcTriangle(_vbuff,   _xl, _yb, _z3,   _xl, _yt, _z1,   _xm, _ym, _zm);
            
            ++_x;
        }
        
        ++_y;
    }
    
    vertex_end(_vbuff);
    return _vbuff;
}