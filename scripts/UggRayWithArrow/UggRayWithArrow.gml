// Feather disable all

/// Draws a line between two coordinates.
/// 
/// @param x
/// @param y
/// @param z
/// @param dX
/// @param dY
/// @param dZ
/// @param [color]
/// @param [thickness]
/// @param [wireframe}

function UggRayWithArrow(_x1, _y1, _z1, _dX, _dY, _dZ, _color = UGG_DEFAULT_DIFFUSE_COLOR, _thickness = UGG_LINE_THICKNESS, _wireframe = undefined)
{
    __UGG_GLOBAL
    __UGG_COLOR_UNIFORMS
    static _volumePyramid    = _global.__volumePyramid;
    static _wireframePyramid = _global.__wireframePyramid;
    static _vectorMatrix     = matrix_build_identity();
    
    var _x2 = _x1 + UGG_RAY_LENGTH*_dX;
    var _y2 = _y1 + UGG_RAY_LENGTH*_dY;
    var _z2 = _z1 + UGG_RAY_LENGTH*_dZ;
    
    var _distSqr = _dX*_dX + _dY*_dY + _dZ*_dZ;
    if (_distSqr == 0) return false;
    
    var _invViewMatrix = matrix_inverse(matrix_get(matrix_view));
    var _camX = _invViewMatrix[12];
    var _camY = _invViewMatrix[13];
    var _camZ = _invViewMatrix[14];
    
    var _dot = max(0.1, dot_product_3d(_dX, _dY, _dZ, _camX - _x1, _camY - _y1, _camZ - _z1) / _distSqr);
    var _arrowX = _x1 + _dot*_dX;
    var _arrowY = _y1 + _dot*_dY;
    var _arrowZ = _z1 + _dot*_dZ;
    
    UggArrow(_x1, _y1, _z1,   _arrowX, _arrowY, _arrowZ,   4*_thickness, _color, _thickness, _wireframe);
    UggLine(_arrowX, _arrowY, _arrowZ,   _x2, _y2, _z2,   _color, _thickness, _wireframe);
}