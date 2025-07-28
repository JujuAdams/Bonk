// Feather disable all

/// @param xSize
/// @param ySize
/// @param zSize
/// @param cellXYSize
/// @param cellZSize

function BonkWorld(_xSize, _ySize, _zSize, _cellXYSize, _cellZSize) constructor
{
    __xSize = _xSize;
    __ySize = _ySize;
    __zSize = _zSize;
    
    __cellXYSize = _cellXYSize;
    __cellZSize  = _cellZSize;
    
    __cellXCount = ceil(_xSize / _cellXYSize);
    __cellYCount = ceil(_ySize / _cellXYSize);
    __cellZCount = ceil(_zSize / _cellZSize);
    
    __cellCount = __cellXCount*__cellYCount*__cellZCount;
    __cellArray = array_create_ext(__cellCount, function()
    {
        return [];
    });
    
    
    
    static Add = function(_shape)
    {
        var _aabb = _shape.GetAABB();
        
        var _cellX = clamp(floor((_aabb.x1 / __cellXYSize) - 0.5), 0, __cellXCount-1);
        var _cellY = clamp(floor((_aabb.y1 / __cellXYSize) - 0.5), 0, __cellYCount-1);
        var _cellZ = clamp(floor((_aabb.z1 / __cellZSize ) - 0.5), 0, __cellZCount-1);
        
        var _cellXSize = 1 + clamp(floor((_aabb.x2 / __cellXYSize) + 0.5), 0, __cellXCount-1) - _cellX;
        var _cellYSize = 1 + clamp(floor((_aabb.y2 / __cellXYSize) + 0.5), 0, __cellYCount-1) - _cellY;
        var _cellZSize = 1 + clamp(floor((_aabb.z2 / __cellZSize ) + 0.5), 0, __cellZCount-1) - _cellZ;
        
        var _z = _cellZ;
        repeat(_cellZSize)
        {
            var _y = _cellY;
            repeat(_cellYSize)
            {
                var _x = _cellX;
                repeat(_cellXSize)
                {
                    array_push(__cellArray[_x + __cellXCount*(_y + __cellYCount*_z)], _shape);
                    ++_x;
                }
                
                ++_y;
            }
            
            ++_z;
        }
    }
    
    static GetShapeArray = function(_x, _y, _z)
    {
        return __cellArray[clamp(floor(_x / __cellXYSize), 0, __cellXCount-1) + __cellXCount*(clamp(floor(_y / __cellXYSize), 0, __cellYCount-1) + __cellYCount*clamp(floor(_z / __cellZSize ), 0, __cellZCount-1))];
    }
}