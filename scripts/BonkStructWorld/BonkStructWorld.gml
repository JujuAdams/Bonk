// Feather disable all

/// Constructor to make a struct that organizes a large group of Bonk shapes into a 3D grid for
/// quick collision queries.
/// 
/// `.Add(shape)`
///     Adds the shape permanently to the "world".
/// 
/// `.PointTouch(x, y, z)`
///     Returns whether the given point in space is inside the world's axis-aligned bounding box.
/// 
/// `.CellInside(x, y, z)`
///     Returns whether the given cell is inside the world's axis-aligned bounding box.
/// 
/// `.Collide(subjectShape)`
///     Returns the vector that separates the subject shape from any collision in the target world.
///     This method returns a struct that contains the following variables:
///     
///     `.collision`
///         Whether a collision was found. If no collision is found, this variable is set to `false`.
///     
///     `.x` `.y` `.z`
///         The vector that separates the two shapes. If there is no collision, all three variables
///         will be set to `0`.
/// 
///     N.B. The returned struct is statically allocated. Reusing `.Collide()` may cause the same struct
///          to be returned.
/// 
/// `.Deflect(subjectShape, [slopeThreshold=0])`
///     Pushes the subject shape out of the shapes added to the world. The slope threshold will
///     allow shapes to "stand" on slopes instead of sliding down them. The units of this parameter
///     are degrees. An angle of `0` represents a perfectly horizontal floor plane. Increase this
///     value to allow shapes to stand on steeper slopes.
/// 
/// `.GetShapeArrayFromPoint(x, y, z)`
///     Returns an array that contains shapes that may overlap with the specified point.
/// 
/// `.GetShapeArrayFromCell(x, y, z)`
///     Returns an array that contains shapes that may overlap with the specified cell.
/// 
/// `.GetCellsFromShape(shape)`
///     Returns an array of cells that a line or ray shape intersects. This array can be empty if the
///     line doesn't intersect any cells. The array is one-dimensional and ordered with sequential
///     triplets for the x/y/z position of each cell.
/// 
/// `.GetCellsFromLine(x1, y1, z1, x2, y2, z2)`
///     Returns an array of cells that the line segment intersects. This array can be empty if the line
///     doesn't intersect any cells. The array is one-dimensional and ordered with sequential triplets
///     for the x/y/z position of each cell.
/// 
/// `.GetAABB()`
///     Returns a struct containing the bounding box for the BonkStructWorld.
/// 
/// `.AddVertexBuffer(vertexBufferOrArray, vertexFormat, [matrix])`
///     Adds triangles from a vertex buffer as collidable shapes to the world. The vertex buffer
///     must be formatted as a triangle list (`pr_trianglelist`). You may provide an array of
///     vertex buffers instead of a single vertex buffer. You may provide a matrix to transform
///     vertices.
///     
///     N.B.  This method is slow in itself and, in general, you should avoid mesh collisions as
///           much as possible because collisions with triangles is also slow.
/// 
/// `.DrawAABB([color], [wireframe=true])`
///     Draws the axis-aligned bounding box for the BonkStructWorld.
/// 
/// `.DrawShapesFromArray(array, [color], [wireframe=true])`
///     Draws shapes that are assigned to cells taken from an array. The array of cells should be one-
///     dimensional and structured with each cell  position appearing as consecutive x/y/z values. This
///     is the same format as returned by `.GetCellsFromShape()` and `.GetCellsFromLine()`.
/// 
/// `.DrawShapesFromRange(struct, [color], [wireframe=true])`
///     Draws shapes that are assigned to cells in the range determined by the input struct. The struct
///     should be formatted in the same way as the `.GetAABB()` getter for BonkStructWorld (and other Bonk
///     shapes) i.e. it should include `.xMin` `.xMax` etc.
/// 
/// `.DrawShapes([color], [wireframe=true])`
///     Draws all shapes in the BonkStructWorld.
/// 
/// `.DrawCellsFromArray(array, [color], [wireframe=true])`
///     Draws cells from an array. The array should be one-dimensional and structured with each cell
///     position appearing as consecutive x/y/z values. This is the same format as returned by
///     `.GetCellsFromShape()` and `.GetCellsFromLine()`.
/// 
/// `.DrawCellsFromRange(struct, [color], [wireframe=true], [checkerboard=false])`
///     Draws cells in the range determined by the input struct. The struct should be formatted in the
///     same way as the `.GetAABB()` getter for BonkStructWorld (and other Bonk shapes) i.e. it should include
///     `.xMin` `.xMax` etc.  The checkerboard argument, when set to `true`, will skip drawing of every
///     other voxel to improve performance.
/// 
/// `.DrawCells([color], [wireframe=true], [checkerboard=true])`
///     Draws all cells (voxels) in the BonkStructWorld. The checkerboard argument, when set to `true`, will
///     skip drawing of every other voxel to improve performance.
///     
/// @param cellXSize
/// @param cellYSize
/// @param cellZSize

function BonkStructWorld(_cellXSize, _cellYSize, _cellZSize) constructor
{
    __BonkCommonWorld(_cellXSize, _cellYSize, _cellZSize);
}