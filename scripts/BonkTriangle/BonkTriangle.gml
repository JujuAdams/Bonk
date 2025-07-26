// Feather disable all

/// Constructor that generates a triangle.
/// 
/// Using the `.Collide(otherShape)` method, this shape can collide with:
/// - Capsule
/// - CylinderExt
/// - Sphere
/// 
/// @param x1
/// @param y1
/// @param z1
/// @param x2
/// @param y2
/// @param z2
/// @param x3
/// @param y3
/// @param z3

function BonkTriangle(_x1, _y1, _z1, _x2, _y2, _z2, _x3, _y3, _z3) : __BonkClassShared() constructor
{
    static bonkType = BONK_TYPE_TRIANGLE;
    
    static _collideFuncLookup = (function()
    {
        var _array = array_create(BONK_NUMBER_OF_TYPES, undefined);
        _array[@ BONK_TYPE_CAPSULE     ] = BonkTriangleCollideCapsule;
        _array[@ BONK_TYPE_CYLINDER_EXT] = BonkTriangleCollideCapsule;
        _array[@ BONK_TYPE_SPHERE      ] = BonkTriangleCollideSphere;
        return _array;
    })();
    
    static _insideFuncLookup = (function()
    {
        var _array = array_create(BONK_NUMBER_OF_TYPES, undefined);
        _array[@ BONK_TYPE_CAPSULE     ] = BonkTriangleInsideCapsule;
        _array[@ BONK_TYPE_CYLINDER_EXT] = BonkTriangleInsideCapsule;
        _array[@ BONK_TYPE_SPHERE      ] = BonkTriangleInsideSphere;
        return _array;
    })();
    
    
    
    x1 = _x1;
    y1 = _y1;
    z1 = _z1;
    
    x2 = _x2;
    y2 = _y2;
    z2 = _z2;
    
    x3 = _x3;
    y3 = _y3;
    z3 = _z3;
    
    
    
    static Draw = function(_color = undefined, _wireframe = undefined)
    {
        __BONK_VERIFY_UGG
        UggTriangle(x1, y1, z1,   x2, y2, z2,   x3, y3, z3,   _color, _wireframe);
    }
}