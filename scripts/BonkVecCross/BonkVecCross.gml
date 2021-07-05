/// @param a
/// @param b

function BonkVecCross(_a, _b)
{
    return [ _a[2]*_b[1] - _a[1]*_b[2],
             _a[0]*_b[2] - _a[2]*_b[0],
             _a[1]*_b[0] - _a[0]*_b[1] ];
}