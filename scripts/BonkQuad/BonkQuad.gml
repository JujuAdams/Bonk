// Feather disable all

/// Constructor that generates a quad. Vertices must be defined in a clockwise order. Only three
/// vertices need to be provided, the fourth coordinate is automatically generated using the
/// following formulas `P4 = P2 + (P1 - P3)` (which is equivalent to `P4 = P3 + (P2 - P1)`).
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
/// 
/// The struct created by the constructor contains the following values:
/// `.x1` `.y1` `.z1`  Coordinate of the "top-left" of the quad.
/// `.x2` `.y2` `.z2`  Coordinate of the "top-right" of the quad.
/// `.x3` `.y3` `.z3`  Coordinate of the "bottom-left" of the quad.
/// 
/// You may use the `.Draw(color, thickness, wireframe)` method to draw the shape, though this
/// method requires installation of Ugg. Please see https://github.com/jujuadams/Ugg
/// 
/// Using the `.Inside(otherShape)` method, this shape can test for an overlap with these shapes:
/// - Capsule
/// - CylinderExt
/// - Sphere
/// 
/// The `.Inside()` method returns either `true` or `false` indicating whether the two shapes
/// overlap. `.Inside()` is usually a little faster than `.Collide()` (see below) and is easier to
/// use.
/// 
/// Using the `.Collide(otherShape)` method, this shape can collide with:
/// - Capsule
/// - CylinderExt
/// - Sphere
/// 
/// The `.Collide()` method returns a "reaction" struct (instanceof `__BonkClassHit`). This struct
/// has four values:
/// 
/// `.collision`       Boolean, whether the shapes overlap.
/// `.dX` `.dY` `.dZ`  Distance to push ourselves to escape the collision.

function BonkQuad(_x1, _y1, _z1, _x2, _y2, _z2, _x3, _y3, _z3) : __BonkClassShared() constructor
{
    static bonkType = BONK_TYPE_QUAD;
    
    static _collideFuncLookup = (function()
    {
        var _array = array_create(BONK_NUMBER_OF_TYPES, undefined);
        _array[@ BONK_TYPE_CAPSULE     ] = BonkQuadCollideCapsule;
        _array[@ BONK_TYPE_CYLINDER_EXT] = BonkQuadCollideCapsule;
        _array[@ BONK_TYPE_SPHERE      ] = BonkQuadCollideSphere;
        return _array;
    })();
    
    static _insideFuncLookup = (function()
    {
        var _array = array_create(BONK_NUMBER_OF_TYPES, undefined);
        _array[@ BONK_TYPE_CAPSULE     ] = BonkQuadInsideCapsule;
        _array[@ BONK_TYPE_CYLINDER_EXT] = BonkQuadInsideCapsule;
        _array[@ BONK_TYPE_SPHERE      ] = BonkQuadInsideSphere;
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
        UggQuad(x1, y1, z1,   x2, y2, z2,   x3, y3, z3,   _color, _wireframe);
    }
}