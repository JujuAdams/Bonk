// Feather disable all

/// Sets the currently scoped instance as a Bonk instance that can be used to stored Bonk structs
/// in a spatial hash map. This is useful for storing static meshes generated from 3D models.
/// 
/// In general, setting up an instance to work with Bonk will do the following things:
/// 
///  1. Set the following native GameMaker variables:
///     `x`  `y`  `mask_index`  `image_xscale`  `image_yscale`  `image_angle`  (and maybe `depth`)
/// 
///  2. Set variables that Bonk needs to operate
///     `z`  `bonkType`  `bonkGroup`  `__bonkCollideFuncLookup`  `__bonkTouchFuncLookup`
///     (and maybe `bonkCreateCallstack`)
/// 
///  3. Set variables to Bonk methods
///     `SetPosition()`  `AddPosition()`  `Touch()`  `Collide()`  `Deflect()`  `LineHit()`
///     `FilterTest()`  `DebugDraw()`  `DebugDrawMask()`
/// 
///  4. Set a handful of further variables and methods for the specific shape type
/// 
/// You can read about the how to use the shared general variables and methods in the
/// `Bonk Instance Details` Note asset found in the same asset browset folder as this function. The
/// following variables and methods are unique to this type of shape:
/// 
/// `.x` `.y` `.z`
///   These variables are **read-only** for this shape type and are derived by calculating the
///   centre of the world when adding new shape structs to it.
/// 
/// `.Add(shapeStruct)`
///   Adds a Bonk shape struct to the world. If the struct exists outside the bounding box of the
///   world then the world will expand to include the shape. Shapes may only be in one world at a
///   time.
/// 
/// `.AddVertexBuffer(vertexBufferOrArray, vertexFormat, [matrix])`
///   Adds triangles from a `pr_trianglelist` vertex buffer as collisions to the world. You may
///   provide a matrix to transform the position/size/angle of the triangle. You should be very
///   careful about adding too many triangles in one location. Try to use a low poly mesh for
///   collisions and keep the triangle density low.
/// 
/// `.CellInside(x, y, z)`
///   Returns if the given cell exists within the bounding box of the world.
/// 
/// `.GetCellsFromLine(lineOrRayShape)`
///   Returns an array of sequential x/y/z cell coordinate triplets that compromise the supercover
///   for the line within the world. You may iterate over these coordinates to inspect what shapes
///   may intersect with the line/ray shape.
/// 
/// `.GetCellsFromLineExt(x1, y1, z1, x2, y2, z2)`
///   Returns an array of sequential x/y/z cell coordinate triplets that compromise the supercover
///   for the line within the world. You may iterate over these coordinates to inspect what shapes
///   may intersect with the line/ray shape.
/// 
/// `.GetShapeArrayFromPoint(x, y, z)`
///   Returns an array of shapes that can be found in the cell corresponding to the coordinate
///   provided. These coordinates are in worldspace and are **not** cell coordinates.
/// 
/// `.GetShapeArrayFromCell(x, y, z)`
///   Returns an array of shapes that can be found in the given cell. These coordinates are cell
///   coordinates and are **not** worldspace.
/// 
/// `.DrawAABB([color], [wireframe=true])`
///   Draws the axis-aligned bounding box for the world.
/// 
/// `.DrawShapesFromRange(aabbStruct, [color], [wireframe])`
///   Draws all shapes in cells that cover the range of worldspace coordinates given by the AABB
///   struct. This struct should contain the following variables: `.xMin` `.yMin` `.zMIn` `.xMax`
///   `.yMax` `.zMax`. This function is compatible with the `.GetAABB()` method found in many
///   Bonk structs/instances.
/// 
/// `.DrawShapesFromArray(cellCoordArray, [color], [wireframe])`
///   Draws all shapes in cells found in the provided array. Array should provide cell coordinates
///   as sequential x/y/z triplets. This function is compatible with the `.GetCellsFromLine()`
///   and `.GetCellsFromLineExt()` methods.
/// 
/// `.DrawShapes([color], [wireframe])`
///   Draws all shapes in the world. This is very slow and should only be used for debugging!
/// 
/// `.DrawCellsFromRange(aabbStruct, [color], [wireframe=true], [checkboard=false])`
///   Draws all cells that cover the range of worldspace coordinates given by the AABB struct.
///   This struct should contain the following variables: `.xMin` `.yMin` `.zMIn` `.xMax` `.yMax`
///   `.zMax`. This function is compatible with the `.GetAABB()` method found in many Bonk
///   structs/instances. If the optional `checkerboard` parameter is set to `true` then every other
///   cell will be skipped which halves the number of cells drawn.
/// 
/// `.DrawCellsFromArray(cellCoordArray, [color], [wireframe])`
///   Draws all cells found in the provided array. Array should provide cell coordinates as
///   sequential x/y/z triplets. This function is compatible with the `.GetCellsFromLine()` and
///   `.GetCellsFromLineExt()` methods.
/// 
/// `.DrawCells(aabbStruct, [color], [wireframe=true], [checkboard=true])`
///   Draws all cells in the world. This is very slow and should only be used for debugging! If the
///   optional `checkerboard` parameter is set to `false` then every cell will be drawn which
///   doubles the number of cells drawn.
/// 
/// `.__bonk*`
///   Various cached values that are used to speed up collision detection. These are **read-only**
///   and even then you'll probably never need to read these variables.
/// 
/// @param cellXSize
/// @param cellYSize
/// @param cellZSize

function BonkSetupWorld(_cellXSize, _cellYSize, _cellZSize)
{
    if (not __BonkIsInstance())
    {
        __BonkError("Must only be called on an object instance");
    }
    
    if (BONK_DEBUG_INSTANCES)
    {
        bonkCreateCallstack = debug_get_callstack();
        array_pop(bonkCreateCallstack);
    }
    
    __BonkCommonWorld(_cellXSize, _cellYSize, _cellZSize);
    
    mask_index = __BonkMaskAAB;
    image_xscale = 0;
    image_yscale = 0;
    
    DebugDrawMask = function(_color = c_white)
    {
        draw_sprite_ext(mask_index, 0, x, y, image_xscale, image_yscale, image_angle, _color, 1);
    }
}