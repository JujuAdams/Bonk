// Feather disable all

/// Returns the position on the screen where the position in world space would appear. The output
/// position may be be out of the bounds of the screen. The input coordinates should be in world
/// space. You must provide a view and projection matrix but you do not have to provide a world
/// matrix (use `undefined` to not use a world matrix). Despite the name, this function can be used
/// with surfaces etc. so long as the "screen" width/height are accurate.
/// 
/// This function returns a struct that contains `x` and `y` which is the coordinate on the screen
/// where the point appears with `0, 0` being the top-left corner. The struct also contains a `z`
/// coordinate which is a normalized coordinate where a value of `0` is at the z-near clipping
/// plane and a value of `1` is that the z-far clipping plane (a value outside of the range `0` to
/// `1` is therefore not visible).
/// 
/// @param x
/// @param y
/// @param [worldMatrix]
/// @param viewMatrix
/// @param projMatrix
/// @param screenWidth
/// @param screenHeight

function UtilWorldToScreen(_x, _y, _z, _worldMatrix = undefined, _viewMatrix, _projMatrix, _screenWidth, _screenHeight)
{
    with(UtilWorldToFrustrum(_x, _y, _z, _worldMatrix, _viewMatrix, _projMatrix))
    {
        x =  _screenWidth*(0.5 + 0.5*x);
        y = _screenHeight*(0.5 + 0.5*y);
        return self;
    }
}