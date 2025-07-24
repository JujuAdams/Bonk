// Feather disable all

/// Draws the frame of a frustrum as defined by a view and projection matrix.
/// 
/// N.B. This function is expensive (especially in VM) so use it sparingly.
/// 
/// @param viewMatrix
/// @param projectionMatrix
/// @param [color]
/// @param [thickness]
/// @param [wireframe}

function UggFrustrum(_viewMatrix, _projectionMatrix, _color = undefined, _thickness = undefined, _wireframe = undefined)
{
    //TODO - Optimise
    
    var _vpMatrixInverse = matrix_inverse(matrix_multiply(_viewMatrix, _projectionMatrix));
    
    var _tlNear = __UggMatrixTransformVertex4DDivW(_vpMatrixInverse, -1, -1, 0, 1);
    var _trNear = __UggMatrixTransformVertex4DDivW(_vpMatrixInverse,  1, -1, 0, 1);
    var _blNear = __UggMatrixTransformVertex4DDivW(_vpMatrixInverse, -1,  1, 0, 1);
    var _brNear = __UggMatrixTransformVertex4DDivW(_vpMatrixInverse,  1,  1, 0, 1);
    
    var _tlFar  = __UggMatrixTransformVertex4DDivW(_vpMatrixInverse, -1, -1, 1, 1);
    var _trFar  = __UggMatrixTransformVertex4DDivW(_vpMatrixInverse,  1, -1, 1, 1);
    var _blFar  = __UggMatrixTransformVertex4DDivW(_vpMatrixInverse, -1,  1, 1, 1);
    var _brFar  = __UggMatrixTransformVertex4DDivW(_vpMatrixInverse,  1,  1, 1, 1);
    
    UggLine(_tlNear[0], _tlNear[1], _tlNear[2],   _trNear[0], _trNear[1], _trNear[2],   _color, _thickness, _wireframe);
    UggLine(_blNear[0], _blNear[1], _blNear[2],   _brNear[0], _brNear[1], _brNear[2],   _color, _thickness, _wireframe);
    UggLine(_tlNear[0], _tlNear[1], _tlNear[2],   _blNear[0], _blNear[1], _blNear[2],   _color, _thickness, _wireframe);
    UggLine(_trNear[0], _trNear[1], _trNear[2],   _brNear[0], _brNear[1], _brNear[2],   _color, _thickness, _wireframe);
    UggLine( _tlFar[0],  _tlFar[1],  _tlFar[2],    _trFar[0],  _trFar[1],  _trFar[2],   _color, _thickness, _wireframe);
    UggLine( _blFar[0],  _blFar[1],  _blFar[2],    _brFar[0],  _brFar[1],  _brFar[2],   _color, _thickness, _wireframe);
    UggLine( _tlFar[0],  _tlFar[1],  _tlFar[2],    _blFar[0],  _blFar[1],  _blFar[2],   _color, _thickness, _wireframe);
    UggLine( _trFar[0],  _trFar[1],  _trFar[2],    _brFar[0],  _brFar[1],  _brFar[2],   _color, _thickness, _wireframe);
    UggLine(_tlNear[0], _tlNear[1], _tlNear[2],    _tlFar[0],  _tlFar[1],  _tlFar[2],   _color, _thickness, _wireframe);
    UggLine(_blNear[0], _blNear[1], _blNear[2],    _blFar[0],  _blFar[1],  _blFar[2],   _color, _thickness, _wireframe);
    UggLine(_trNear[0], _trNear[1], _trNear[2],    _trFar[0],  _trFar[1],  _trFar[2],   _color, _thickness, _wireframe);
    UggLine(_brNear[0], _brNear[1], _brNear[2],    _brFar[0],  _brFar[1],  _brFar[2],   _color, _thickness, _wireframe);
}