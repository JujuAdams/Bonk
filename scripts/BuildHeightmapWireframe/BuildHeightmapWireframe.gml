/// @param grid
/// @param xScale
/// @param yScale
/// @param zScale

function BuildHeightmapWireframe(_grid, _xScale, _yScale, _zScale)
{
    var _width  = ds_grid_width(_grid);
    var _height = ds_grid_width(_grid);
    
    if (_width < 2)
    {
        
    }
    
    if (_height < 2)
    {
        
    }
    
    var _vbuff = vertex_create_buffer();
    vertex_begin(_vbuff, GetHeightmapWireframeVertexFormat());
    
    var _y = 0;
    repeat(_height-1)
    {
        var _x = 0;
        repeat(_width-1)
        {
            var _xl = _xScale*_x;
            var _yt = _yScale*_y;
            var _xm = _xl + 0.5*_xScale;
            var _ym = _yt + 0.5*_yScale;
            var _xr = _xl + _xScale;
            var _yb = _yt + _yScale;
            
            var _z1 = _zScale*_grid[# _x,   _y  ];
            var _z2 = _zScale*_grid[# _x+1, _y  ];
            var _z3 = _zScale*_grid[# _x,   _y+1];
            var _z4 = _zScale*_grid[# _x+1, _y+1];
            var _zm = 0.25*(_z1 + _z2 + _z3 + _z4);
            
            vertex_position_3d(_vbuff, _xl, _yt, _z1); vertex_color(_vbuff, c_white, 1);
            vertex_position_3d(_vbuff, _xr, _yt, _z2); vertex_color(_vbuff, c_white, 1);
            
            vertex_position_3d(_vbuff, _xr, _yt, _z2); vertex_color(_vbuff, c_white, 1);
            vertex_position_3d(_vbuff, _xr, _yb, _z4); vertex_color(_vbuff, c_white, 1);
            
            vertex_position_3d(_vbuff, _xr, _yb, _z4); vertex_color(_vbuff, c_white, 1);
            vertex_position_3d(_vbuff, _xl, _yb, _z3); vertex_color(_vbuff, c_white, 1);
            
            vertex_position_3d(_vbuff, _xl, _yb, _z3); vertex_color(_vbuff, c_white, 1);
            vertex_position_3d(_vbuff, _xl, _yt, _z1); vertex_color(_vbuff, c_white, 1);
            
            
            
            vertex_position_3d(_vbuff, _xl, _yt, _z1); vertex_color(_vbuff, c_white, 1);
            vertex_position_3d(_vbuff, _xm, _ym, _zm); vertex_color(_vbuff, c_white, 1);
            
            vertex_position_3d(_vbuff, _xr, _yt, _z2); vertex_color(_vbuff, c_white, 1);
            vertex_position_3d(_vbuff, _xm, _ym, _zm); vertex_color(_vbuff, c_white, 1);
            
            vertex_position_3d(_vbuff, _xl, _yb, _z3); vertex_color(_vbuff, c_white, 1);
            vertex_position_3d(_vbuff, _xm, _ym, _zm); vertex_color(_vbuff, c_white, 1);
            
            vertex_position_3d(_vbuff, _xr, _yb, _z4); vertex_color(_vbuff, c_white, 1);
            vertex_position_3d(_vbuff, _xm, _ym, _zm); vertex_color(_vbuff, c_white, 1);
            
            ++_x;
        }
        
        ++_y;
    }
    
    vertex_end(_vbuff);
    return _vbuff;
}