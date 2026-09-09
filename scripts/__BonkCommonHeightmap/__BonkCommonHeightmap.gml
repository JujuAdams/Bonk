// Feather disable all

function __BonkCommonHeightmap()
{
    bonkType = BONK_TYPE_HEIGHTMAP;
    
    //TODO - Add async variant
    //TODO - Add partial variant
    UpdateTriangles = function()
    {
        var _function   = heightFunction;
        var _cellWidth  = cellWidth;
        var _cellHeight = cellHeight
        var _xScale     = xScale;
        var _yScale     = yScale;
        var _zScale     = zScale;
        
        __bonkWidth  = xScale*_cellWidth;
        __bonkHeight = yScale*_cellHeight;
        
        var _bonkTriangleArray = __bonkTriangleArray;
        var _minZArray = __bonkMinZArray;
        var _maxZArray = __bonkMaxZArray;
        
        array_resize(_bonkTriangleArray, 2*_cellWidth*_cellHeight);
        array_resize(_minZArray, _cellWidth*_cellHeight);
        array_resize(_maxZArray, _cellWidth*_cellHeight);
        
        var _z00 = undefined;
        var _z10 = undefined;
        var _z01 = undefined;
        var _z11 = _zScale*_function(0, 0);
        
        var _y0 = undefined;
        var _y1 = 0;
        
        var _zMinCell    = _z11;
        var _zMaxCell    = _z11;
        var _zMinOverall = _z11;
        var _zMaxOverall = _z11;
        
        var _index = 0;
        var _yCell = 0;
        repeat(_cellHeight)
        {
            _y0 = _y1;
            _y1 = _y0 + _yScale;
            
            _z10 = _zScale*_function(0, _yCell);
            _z11 = _zScale*_function(0, _yCell+1);
            
            _zMinCell = min(_zMinCell, _z10, _z11);
            _zMaxCell = max(_zMaxCell, _z10, _z11);
            
            var _x0 = undefined;
            var _x1 = 0;
            
            var _xCell = 0;
            repeat(_cellWidth)
            {
                _x0 = _x1;
                _x1 = _x0 + _xScale;
                
                _z00 = _z10;
                _z01 = _z11;
                _z10 = _zScale*_function(_xCell+1, _yCell);
                _z11 = _zScale*_function(_xCell+1, _yCell+1);
                
                _zMinCell    = min(_zMinCell, _z10, _z11);
                _zMaxCell    = max(_zMaxCell, _z10, _z11);
                _zMinOverall = min(_zMinCell, _zMinOverall);
                _zMaxOverall = max(_zMaxCell, _zMaxOverall);
                
                _minZArray[@ _index/2] = _zMinCell;
                _maxZArray[@ _index/2] = _zMaxCell;
                
                // TODO - Alternate handedness of triangles
                // TODO - Set soft edges
                
                _bonkTriangleArray[@ _index++] = new BonkStructTriangle(_x0, _y0, _z00,   _x1, _y0, _z10,   _x0, _y1, _z01);
                _bonkTriangleArray[@ _index++] = new BonkStructTriangle(_x0, _y1, _z01,   _x1, _y0, _z10,   _x1, _y1, _z11);
                
                ++_xCell;
            }
            
            ++_yCell;
        }
        
        __bonkMinZ = _zMinOverall;
        __bonkMaxZ = _zMaxOverall;
    }
    
    GetHeightAt = function(_x, _y)
    {
        var _xCell = (_x - x) / xScale;
        if ((_xCell < 0) || (_xCell > cellWidth-1))
        {
            return undefined;
        }
        
        var _yCell = (_y - y) / yScale;
        if ((_yCell < 0) || (_yCell > cellHeight-1))
        {
            return undefined;
        }
        
        return zScale*heightFunction(_xCell, _yCell);
    }
    
    GetNormalAt = function(_x, _y)
    {
        //TODO - Is this correct?
        
        static _result = {
            x: 0,
            y: 0,
            z: 0,
        };
        
        var _dx12 = 0.01;
        var _dy13 = 0.01;
        
        var _heightC = GetHeight(_x,         _y        );
        var _heightR = GetHeight(_x + _dx12, _y        );
        var _heightB = GetHeight(_x,         _y + _dy13);
        
        with(_result)
        {
            if ((_heightC == undefined) || (_heightR == undefined) || (_heightB == undefined))
            {
                x = 0;
                y = 0;
                z = 1;
            }
            else
            {
                var _dz12 = _heightR - _heightC;
                var _dz13 = _heightB - _heightC;
                
                x =  _dz12*_dy13;
                y =  _dx12*_dz13;
                z = -_dx12*_dy13;
            }
            
            return self;
        }
    }
    
    GetAABB = function()
    {
        return {
            xMin: x,
            yMin: y,
            zMin: z + __bonkMinZ,
            xMax: x + __bonkWidth,
            yMax: y + __bonkHeight,
            zMax: z + __bonkMaxZ,
        };
    }
    
    GetAABB = function()
    {
        return {
            xMin: bbox_left,
            yMin: bbox_top,
            zMin: z + __bonkMinZ,
            xMax: bbox_right,
            yMax: bbox_bottom,
            zMax: z + __bonkMaxZ,
        };
    }
    
    LineHit = function(_x1, _y1, _z1, _x2, _y2, _z2, _groupFilter = -1, _struct = undefined)
    {
        return BonkLineHitHeightmap(self, _x1, _y1, _z1, _x2, _y2, _z2, _groupFilter, _struct);
    }
    
    Touch = function(_subjectShape, _groupFilter = -1)
    {
        var _cellWidth  = cellWidth;
        var _cellHeight = cellHeight;
        
        var _bonkTriangleArray = __bonkTriangleArray;
        
        var _aabb = _subjectShape.GetAABB();
        
        var _shapeXMin = floor((_aabb.xMin - x) / xScale);
        var _shapeYMin = floor((_aabb.yMin - y) / yScale);
        var _shapeZMin = floor((_aabb.zMin - z) / zScale);
        
        var _shapeXMax = floor((_aabb.xMax - x) / xScale);
        var _shapeYMax = floor((_aabb.yMax - y) / yScale);
        var _shapeZMax = floor((_aabb.zMax - z) / zScale);
        
        if ((_shapeXMin > _cellWidth-1) || (_shapeYMin > _cellHeight-1) || (_shapeZMin > __bonkMaxZ)
        ||  (_shapeXMax < 0) || (_shapeYMax < 0) || (_shapeZMax < __bonkMinZ))
        {
            //Shape is outside bounds
            return false;
        }
        
        _shapeXMin = clamp(_shapeXMin, 0, _cellWidth-1);
        _shapeYMin = clamp(_shapeYMin, 0, _cellHeight-1);
        
        _shapeXMax = clamp(_shapeXMax, 0, _cellWidth-1);
        _shapeYMax = clamp(_shapeYMax, 0, _cellHeight-1);
        
        var _cellCheckWidth = 2*(1 + _shapeXMax - _shapeXMin);
        
        var _y = _shapeYMin;
        repeat(1 + _shapeYMax - _shapeYMin)
        {
            var _index = 2*(_shapeXMin + _cellWidth*_y);
            
            repeat(2*_cellCheckWidth)
            {
                if (_bonkTriangleArray[_index++].Touch(_subjectShape, _groupFilter))
                {
                    return true;
                }
            }
            
            ++_y;
        }
        
        return false;
    }
    
    Deflect = function(_subjectShape, _slopeThreshold = 0, _groupFilter = -1)
    {
        static _staticDeflect = new BonkResultDeflect();
        var _result = _staticDeflect;
        
        var _largestGrippyDepth   = -infinity;
        var _largestSlipperyDepth = -infinity;
        
        var _cellWidth  = cellWidth;
        var _cellHeight = cellHeight;
        
        var _bonkTriangleArray = __bonkTriangleArray;
        
        var _aabb = _subjectShape.GetAABB();
        
        var _shapeXMin = floor((_aabb.xMin - x) / xScale);
        var _shapeYMin = floor((_aabb.yMin - y) / yScale);
        var _shapeZMin = floor((_aabb.zMin - z) / zScale);
        
        var _shapeXMax = floor((_aabb.xMax - x) / xScale);
        var _shapeYMax = floor((_aabb.yMax - y) / yScale);
        var _shapeZMax = floor((_aabb.zMax - z) / zScale);
        
        if ((_shapeXMin > _cellWidth-1) || (_shapeYMin > _cellHeight-1) || (_shapeZMin > __bonkMaxZ)
        ||  (_shapeXMax < 0) || (_shapeYMax < 0) || (_shapeZMax < __bonkMinZ))
        {
            //Shape is outside bounds
        }
        else
        {
            _shapeXMin = clamp(_shapeXMin, 0, _cellWidth-1);
            _shapeYMin = clamp(_shapeYMin, 0, _cellHeight-1);
            
            _shapeXMax = clamp(_shapeXMax, 0, _cellWidth-1);
            _shapeYMax = clamp(_shapeYMax, 0, _cellHeight-1);
            
            var _cellCheckWidth = 2*(1 + _shapeXMax - _shapeXMin);
            
            var _y = _shapeYMin;
            repeat(1 + _shapeYMax - _shapeYMin)
            {
                var _index = 2*(_shapeXMin + _cellWidth*_y);
                repeat(_cellCheckWidth)
                {
                    var _reaction = _bonkTriangleArray[_index++].Deflect(_subjectShape, _slopeThreshold, _groupFilter);
                    if (_reaction.deflectType != BONK_DEFLECT_NONE)
                    {
                        with(_reaction.grippyCollision)
                        {
                            if (shape != undefined)
                            {
                                var _depth = dX*dX + dY*dY + dZ*dZ;
                                if (_depth > _largestGrippyDepth)
                                {
                                    _largestGrippyDepth = _depth;
                                    __CopyTo(_result.grippyCollision);
                                }
                            }
                        }
                        
                        with(_reaction.slipperyCollision)
                        {
                            if (shape != undefined)
                            {
                                var _depth = dX*dX + dY*dY + dZ*dZ;
                                if (_depth > _largestSlipperyDepth)
                                {
                                    _largestSlipperyDepth = _depth;
                                    __CopyTo(_result.slipperyCollision);
                                }
                            }
                        }
                    }
                }
                
                ++_y;
            }
        }
        
        with(_result)
        {
            if (not is_infinity(_largestGrippyDepth))
            {
                primaryCollision = grippyCollision;
                deflectType = BONK_DEFLECT_GRIPPY;
                
                if (is_infinity(_largestSlipperyDepth))
                {
                    slipperyCollision.__Null();
                }
            }
            else
            {
                grippyCollision.__Null();
                primaryCollision = slipperyCollision;
                
                if (not is_infinity(_largestSlipperyDepth))
                {
                    deflectType = BONK_DEFLECT_SLIPPERY;
                }
                else
                {
                    slipperyCollision.__Null();
                    deflectType = BONK_DEFLECT_NONE;
                }
            }
            
            return self;
        }
    }
    
    Collide = function(_subjectShape, _groupFilter = -1, _struct = undefined)
    {
        static _nullCollisionData = new BonkResultCollide();
        
        var _cellWidth  = cellWidth;
        var _cellHeight = cellHeight;
        
        var _bonkTriangleArray = __bonkTriangleArray;
        
        var _aabb = _subjectShape.GetAABB();
        
        var _shapeXMin = floor((_aabb.xMin - x) / xScale);
        var _shapeYMin = floor((_aabb.yMin - y) / yScale);
        var _shapeZMin = floor((_aabb.zMin - z) / zScale);
        
        var _shapeXMax = floor((_aabb.xMax - x) / xScale);
        var _shapeYMax = floor((_aabb.yMax - y) / yScale);
        var _shapeZMax = floor((_aabb.zMax - z) / zScale);
        
        if ((_shapeXMin > _cellWidth-1) || (_shapeYMin > _cellHeight-1) || (_shapeZMin > __bonkMaxZ)
        ||  (_shapeXMax < 0) || (_shapeYMax < 0) || (_shapeZMax < __bonkMinZ))
        {
            //Shape is outside bounds
            return _nullCollisionData;
        }
        
        _shapeXMin = clamp(_shapeXMin, 0, _cellWidth-1);
        _shapeYMin = clamp(_shapeYMin, 0, _cellHeight-1);
        
        _shapeXMax = clamp(_shapeXMax, 0, _cellWidth-1);
        _shapeYMax = clamp(_shapeYMax, 0, _cellHeight-1);
        
        var _cellCheckWidth = 2*(1 + _shapeXMax - _shapeXMin);
        
        var _y = _shapeYMin;
        repeat(1 + _shapeYMax - _shapeYMin)
        {
            var _index = 2*(_shapeXMin + _cellWidth*_y);
            
            repeat(2*_cellCheckWidth)
            {
                var _reaction = _bonkTriangleArray[_index++].Collide(_subjectShape, _groupFilter, _struct);
                if (_reaction.shape != undefined)
                {
                    return _reaction;
                }
            }
            
            ++_y;
        }
        
        return (_struct == undefined)? _nullCollisionData : _struct.__Null();
    }
    
    GetAABB = function()
    {
        return {
            xMin: x,
            yMin: y,
            zMin: z + __bonkMinZ,
            
            xMax: x + __bonkWidth,
            yMax: y + __bonkHeight,
            zMax: z + __bonkMaxZ,
        };
    }
    
    GetShapeArrayFromPoint = function(_x, _y)
    {
        return GetShapeArrayFromCell((_x - x) / xScale, (_y - y) / yScale);
    }
    
    GetShapeArrayFromCell = function(_xCell, _yCell)
    {
        static _array = [];
        
        if ((_xCell < 0) || (_xCell > cellWidth-1) || (_yCell < 0) || (_yCell > cellHeight-1))
        {
            array_resize(_array, 0);
        }
        else
        {
            array_resize(_array, 2);
            array_copy(_array, 0, __bonkTriangleArray, _xCell + _yCell*cellWidth, 2);
        }
        
        return _array;
    }
    
    DrawAABB = function(_color = undefined, _wireframe = true)
    {
        __BONK_VERIFY_UGG
        
        with(GetAABB())
        {
            UggAABB(0.5*(xMin + xMax), 0.5*(yMin + yMax), 0.5*(zMin + zMax),
                    xMax - xMin, yMax - yMin, zMax - zMin,
                    _color, _wireframe);
        }
    }
    
    DrawShapesFromRange = function(_struct, _color = undefined, _wireframe = undefined)
    {
        var _cellWidth  = cellWidth;
        var _cellHeight = cellHeight;
        
        var _xShape = x;
        var _yShape = y;
        var _zShape = z;
        
        var _bonkTriangleArray = __bonkTriangleArray;
        
        var _zMin = _struct.zMin - z;
        var _zMax = _struct.zMax - z;
        if ((_zMin > __bonkMaxZ) || (_zMax < __bonkMinZ))
        {
            //Range is outside bounds
            return;
        }
        
        var _xMin = floor((_struct.xMin - _xShape) / xScale);
        var _yMin = floor((_struct.yMin - _yShape) / yScale);
        
        var _xMax = floor((_struct.xMax - _xShape) / xScale);
        var _yMax = floor((_struct.yMax - _yShape) / yScale);
        
        if ((_xMin > _cellWidth-1) || (_yMin > _cellHeight-1) || (_xMax < 0) || (_yMax < 0))
        {
            //Range is outside bounds
            return;
        }
        
        _xMin = clamp(_xMin, 0, _cellWidth-1);
        _yMin = clamp(_yMin, 0, _cellHeight-1);
        
        _xMax = clamp(_xMax, 0, _cellWidth-1);
        _yMax = clamp(_yMax, 0, _cellHeight-1);
        
        var _cellCheckWidth = 2*(1 + _xMax - _xMin);
        
        //FIXME - Apply transformation matrix here to move the shapes
        
        var _y = _yMin;
        repeat(1 + _yMax - _yMin)
        {
            var _index = 2*(_xMin + _cellWidth*_y);
            repeat(2*_cellCheckWidth)
            {
                _bonkTriangleArray[_index++].DebugDraw(_color, _wireframe);
            }
            
            ++_y;
        }
    }
    
    DrawShapesFromArray = function(_array, _color = undefined, _wireframe = undefined)
    {
        var _cellWidth  = cellWidth;
        var _cellHeight = cellHeight;
        
        var _xShape = x;
        var _yShape = y;
        var _zShape = z;
        
        var _xScale = xScale;
        var _yScale = yScale;
        
        var _zMin = _zShape + __bonkMinZ;
        var _zMax = _zShape + __bonkMaxZ;
        
        var _bonkTriangleArray = __bonkTriangleArray;
        
        //FIXME - Apply transformation matrix here to move the shapes
        
        var _i = 0;
        repeat(array_length(_array) div 3)
        {
            var _z = _array[_i+2];
            if ((_z >= _zMin) && (_z <= _zMax))
            {
                var _xCell = floor((_array[_i  ] - _xShape) / _xScale);
                var _yCell = floor((_array[_i+1] - _yShape) / _yScale);
                
                if ((_xCell >= 0) && (_yCell >= 0) && (_xCell <= _cellWidth-1) && (_yCell <= _cellHeight-1))
                {
                    var _index = 2*(_xCell + _cellWidth*_yCell);
                    _bonkTriangleArray[_index  ].DebugDraw(_color, _wireframe);
                    _bonkTriangleArray[_index+1].DebugDraw(_color, _wireframe);
                }
            }
            
            ++_i;
        }
    }
    
    DrawShapes = function(_color = undefined, _wireframe = undefined)
    {
        //FIXME - Apply transformation matrix here to move the shapes
        
        var _bonkTriangleArray = __bonkTriangleArray;
        var _i = 0;
        repeat(array_length(_bonkTriangleArray))
        {
            _bonkTriangleArray[_i].DebugDraw(_color, _wireframe);
            ++_i;
        }
    }
    
    DebugDraw = DrawShapes;
    
    //DebugDraw = function(_color = undefined, _wireframe = undefined)
    //{
    //    __BONK_VERIFY_UGG
    //    
    //    var _subdivision = 6;
    //    
    //    var _x = x;
    //    var _y = y;
    //    var _z = z;
    //    
    //    var _xScale = xScale;
    //    var _yScale = yScale;
    //    var _zScale = zScale;
    //    
    //    var _heightFunction = heightFunction;
    //    
    //    var _yWorld = _y;
    //    var _yCell = 0;
    //    repeat(_subdivision*(cellHeight-1) + 1)
    //    {
    //        var _xWorld = _x;
    //        var _xCell = 0;
    //        repeat(_subdivision*(cellWidth-1) + 1)
    //        {
    //            var _height = _z + _zScale*_heightFunction(_xCell, _yCell);
    //            
    //            UggPoint(_xWorld, _yWorld, _height, _color, _wireframe);
    //            
    //            _xWorld += _xScale/_subdivision;
    //            _xCell += 1/_subdivision;
    //        }
    //        
    //        _yWorld += _yScale/_subdivision;
    //        _yCell += 1/_subdivision;
    //    }
    //}
    
    DrawCellsFromArray = function(_array, _color = undefined, _wireframe = true)
    {
        var _cellWidth  = cellWidth;
        var _cellHeight = cellHeight;
        
        var _xScale = xScale;
        var _yScale = yScale;
        var _zScale = zScale;
        
        var _xShape = x;
        var _yShape = y;
        var _zShape = z + 0.5*_zScale;
        
        var _i = 0;
        repeat(array_length(_array) div 3)
        {
            var _x = floor(_array[_i  ]);
            var _y = floor(_array[_i+1]);
            var _z = floor(_array[_i+2]);
            
            if ((_x >= 0) && (_y >= 0) && (_x <= _cellWidth-1) && (_y <= _cellHeight-1) && (_z == 0))
            {
                UggAABB(_xShape + _xScale*(_x + 0.5),
                        _yShape + _yScale*(_y + 0.5),
                        _zShape,
                        _xScale, _yScale, _zScale,
                        _color, _wireframe);
            }
            
            _i += 3;
        }
    }
    
    DrawCellsFromRange = function(_struct, _color = undefined, _wireframe = true, _checkerboard = false)
    {
        var _cellWidth  = cellWidth;
        var _cellHeight = cellHeight;
        
        var _xScale = xScale;
        var _yScale = yScale;
        var _zScale = zScale;
        
        var _xShape = x;
        var _yShape = y;
        var _zShape = z;
        
        if ((_struct.zMin > _zShape + __bonkMaxZ) || (_struct.zMax < _zShape + __bonkMinZ))
        {
            return;
        }
        
        var _xMin = floor((_struct.xMin - _xShape) / xScale);
        var _yMin = floor((_struct.yMin - _yShape) / yScale);
        
        var _xMax = floor((_struct.xMax - _xShape) / xScale);
        var _yMax = floor((_struct.yMax - _yShape) / yScale);
        
        if ((_xMin > _cellWidth-1) || (_yMin > _cellHeight-1) || (_xMax < 0) || (_yMax < 0))
        {
            //Range is outside bounds
            return;
        }
        
        _xMin = clamp(_xMin, 0, _cellWidth-1);
        _yMin = clamp(_yMin, 0, _cellHeight-1);
        
        _xMax = clamp(_xMax, 0, _cellWidth-1);
        _yMax = clamp(_yMax, 0, _cellHeight-1);
        
        _zShape += 0.5*_zScale;
        
        var _y = _yMin;
        repeat(1 + _yMax - _yMin)
        {
            var _x = _xMin;
            repeat(1 + _xMax - _xMin)
            {
                if ((not _checkerboard) || ((abs(_x + _y) mod 2) == 1))
                {
                    UggAABB(_xShape + _xScale*(_x + 0.5),
                            _yShape + _yScale*(_y + 0.5),
                            _zShape,
                            _xScale, _yScale, _zScale,
                            _color, _wireframe);
                }
                
                ++_x;
            }
            
            ++_y;
        }
    }
    
    DrawCells = function(_color = undefined, _wireframe = true, _checkerboard = true)
    {
        return DrawCellsFromRange(GetAABB(), _color, _wireframe, _checkerboard);
    }
    
    DrawNeighborhoodForRange = function(_aabb, _color)
    {
        DrawCellsFromRange(_aabb);
        
        var _oldEnable = gpu_get_ztestenable();
        var _oldWrite = gpu_get_zwriteenable();
        gpu_set_ztestenable(false);
        gpu_set_zwriteenable(false);
        
        DrawShapesFromRange(_aabb, _color, true);
        
        gpu_set_ztestenable(_oldEnable);
        gpu_set_zwriteenable(_oldWrite);
        
        return self;
    }
    
    DrawNeighborhoodForArray = function(_array, _color)
    {
        DrawCellsFromArray(_array);
        
        var _oldEnable = gpu_get_ztestenable();
        var _oldWrite = gpu_get_zwriteenable();
        gpu_set_ztestenable(false);
        gpu_set_zwriteenable(false);
        
        DrawShapesFromArray(_array, _color, true);
        
        gpu_set_ztestenable(_oldEnable);
        gpu_set_zwriteenable(_oldWrite);
        
        return self;
    }
    
    DrawNeighborhoodForShape = function(_shape, _color)
    {
        DrawNeighborhoodForRange(_shape.GetAABB(), _color);
        
        return self;
    }
    
    DrawNeighborhoodForLine = function(_lineShape, _color)
    {
        DrawNeighborhoodForArray(GetCellsFromLine(_lineShape), _color);
        
        return self;
    }
    
    DrawNeighborhoodForLineExt = function(_x1, _y1, _z1, _x2, _y2, _z2, _color)
    {
        DrawNeighborhoodForArray(GetCellsFromLineExt(_x1, _y1, _z1, _x2, _y2, _z2), _color);
        
        return self;
    }
    
    GetCellsFromLine = function(_lineShape)
    {
        with(_lineShape)
        {
            if (bonkType == BONK_TYPE_LINE)
            {
                return other.GetCellsFromLineExt(x1, y1, z1,   x2, y2, z2);
            }
            else if (bonkType == BONK_TYPE_RAY)
            {
                return other.GetCellsFromLineExt(x, y, z,   x + BONK_RAY_LENGTH*dX, y + BONK_RAY_LENGTH*dY, z + BONK_RAY_LENGTH*dZ);
            }
            else
            {
                __BonkError($"Can only get cells for shapes that are a line or a ray (type was {bonkType})");
            }
        }
        
        return [];
    }
    
    GetCellsFromLineExt = function(_x1, _y1, _z1, _x2, _y2, _z2)
    {
        //FIXME - Return a static array
        
        var _dX = _x2 - _x1;
        var _dY = _y2 - _y1;
        var _dZ = _z2 - _z1;
        
        var _xMin = x;
        var _yMin = y;
        var _zMin = z + __bonkMinZ;
        
        var _xMax = x + __bonkWidth;
        var _yMax = y + __bonkHeight;
        var _zMax = z + __bonkMaxZ;
        
        if (_dX == 0)
        {
            var _t1 = -infinity;
            var _t2 =  infinity;
        }
        else
        {
            var _t1 = (_xMin - _x1) / _dX;
            var _t2 = (_xMax - _x1) / _dX;
        }
        
        if (_dY == 0)
        {
            var _t3 = -infinity;
            var _t4 =  infinity;
        }
        else
        {
            var _t3 = (_yMin - _y1) / _dY;
            var _t4 = (_yMax - _y1) / _dY;
        }
        
        if (_dZ == 0)
        {
            var _t5 = -infinity;
            var _t6 =  infinity;
        }
        else
        {
            var _t5 = (_zMin - _z1) / _dZ;
            var _t6 = (_zMax - _z1) / _dZ;
        }
        
        var _tMin = max(min(_t1, _t2), min(_t3, _t4), min(_t5, _t6));
        var _tMax = min(max(_t1, _t2), max(_t3, _t4), max(_t5, _t6));
        
        if ((_tMax < 0) || (_tMin > 1) || (_tMin > _tMax))
        {
            return [];
        }
        
        _tMin = clamp(_tMin, 0, 1);
        _tMax = clamp(_tMax, 0, 1);
        
        var _t = (_tMin < 0)? _tMax : _tMin;
        
        var _hitX = _x1 + _t*_dX;
        if ((_hitX < _xMin) || (_hitX > _xMax))
        {
            return [];
        }
        
        var _hitY = _y1 + _t*_dY;
        if ((_hitY < _yMin) || (_hitY > _yMax))
        {
            return [];
        }
        
        var _hitZ = _z1 + _t*_dZ;
        if ((_hitZ < _zMin) || (_hitZ > _zMax))
        {
            return [];
        }
        
        var _clampedX1 = _x1 + _tMin*_dX;
        var _clampedY1 = _y1 + _tMin*_dY;
        
        var _clampedX2 = _x1 + _tMax*_dX;
        var _clampedY2 = _y1 + _tMax*_dY;
        
        return __BonkSupercover2D(_clampedX1/xScale, _clampedY1/yScale, _clampedX2/xScale, _clampedY2/yScale);
    }
}