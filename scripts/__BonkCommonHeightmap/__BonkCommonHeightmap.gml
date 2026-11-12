// Feather disable all

/// @param function
/// @param x
/// @param y
/// @param z
/// @param cellCountX
/// @param cellCountY
/// @param xScale
/// @param yScale
/// @param zScale

function __BonkCommonHeightmap(_function, _x, _y, _z, _cellCountX, _cellCountY, _xScale, _yScale, _zScale)
{
    bonkType = BONK_TYPE_HEIGHTMAP;
    
    static _collideFuncLookup = (function()
    {
        //TODO - Make reversed versions of these functions?
        var _array = array_create(BONK_NUMBER_OF_TYPES, undefined);
        _array[@ BONK_TYPE_AAB     ] = BonkAABCollideHeightmap;
        _array[@ BONK_TYPE_OBB     ] = BonkRotatedBoxCollideHeightmap;
        _array[@ BONK_TYPE_CAPSULE ] = BonkCapsuleCollideHeightmap;
        _array[@ BONK_TYPE_CYLINDER] = BonkCylinderCollideHeightmap;
        _array[@ BONK_TYPE_SPHERE  ] = BonkSphereCollideHeightmap;
        return _array;
    })();
    
    static _touchFuncLookup = (function()
    {
        //TODO - Make reversed versions of these functions?
        var _array = array_create(BONK_NUMBER_OF_TYPES, undefined);
        _array[@ BONK_TYPE_AAB     ] = BonkAABTouchHeightmap;
        _array[@ BONK_TYPE_OBB     ] = BonkRotatedBoxTouchHeightmap;
        _array[@ BONK_TYPE_CAPSULE ] = BonkCapsuleTouchHeightmap;
        _array[@ BONK_TYPE_CYLINDER] = BonkCylinderTouchHeightmap;
        _array[@ BONK_TYPE_SPHERE  ] = BonkSphereTouchHeightmap;
        return _array;
    })();
    
    heightFunction = _function;
    heightFunctionXOffset = 0;
    heightFunctionYOffset = 0;
    
    __bonkMinZ = -500;
    __bonkMaxZ =  500;
    
    x = _x;
    y = _y;
    z = _z;
    
    cellCountX = _cellCountX;
    cellCountY = _cellCountY;
    
    xScale = _xScale;
    yScale = _yScale;
    zScale = _zScale;
    
    __bonkWidth  = cellCountX*xScale;
    __bonkHeight = cellCountY*yScale;
    
    
    
    GetZ = function(_x, _y)
    {
        var _xCell = (_x - x) / xScale;
        if ((_xCell < 0) || (_xCell > cellCountX))
        {
            return undefined;
        }
        
        var _yCell = (_y - y) / yScale;
        if ((_yCell < 0) || (_yCell > cellCountY))
        {
            return undefined;
        }
        
        return z + zScale*heightFunction(_xCell, _yCell);
    }
    
    GetNormal = function(_x, _y)
    {
        //TODO - Is this correct?
        
        static _result = {
            x: 0,
            y: 0,
            z: 0,
        };
        
        var _heightC = GetHeight(_x,         _y        );
        var _heightR = GetHeight(_x + 0.001, _y        );
        var _heightB = GetHeight(_x,         _y + 0.001);
        
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
                
                x = -_dz12*0.001;
                y = -0.001*_dz13;
                z =  0.001*0.001;
            }
            
            return self;
        }
    }
    
    LineHit = function(_x1, _y1, _z1, _x2, _y2, _z2, _groupFilter = -1, _struct = undefined)
    {
        static _nullHit = new BonkResultHit();
        
        if ((_groupFilter < 0) || FilterTest(_groupFilter))
        {
            return BonkLineHitHeightmap(self, _x1, _y1, _z1, _x2, _y2, _z2, _struct);
        }
        else
        {
            return (_struct == undefined)? _nullHit : _struct.Null();
        }
    }
    
    Touch = function(_otherShape, _groupFilter = -1, _quietFail = false)
    {
        if ((_groupFilter >= 0) && (not FilterTest(_groupFilter)))
        {
            return false;
        }
        
        var _insideFunc = __bonkTouchFuncLookup[_otherShape.bonkType];
        if (is_callable(_insideFunc))
        {
            return _insideFunc(_otherShape, self);
        }
        else
        {
            if (BONK_STRICT)
            {
                __BonkConditionalError(not _quietFail, $".Touch() not supported between \"{instanceof(self)}\" (type={bonkType}) and \"{instanceof(_otherShape)}\" (type={_otherShape.bonkType})");
            }
        }
        
        return false;
    }
    
    Collide = function(_otherShape, _groupFilter = -1, _struct = undefined, _quietFail = false)
    {
        static _nullCollisionData = new BonkResultCollide();
        
        if ((_groupFilter < 0) || FilterTest(_groupFilter))
        {
            var _collideFunc = __bonkCollideFuncLookup[_otherShape.bonkType];
            if (is_callable(_collideFunc))
            {
                return _collideFunc(_otherShape, self, _struct).__Reverse(self);
            }
            else
            {
                if (BONK_STRICT)
                {
                    __BonkConditionalError(not _quietFail, $".Collide() not supported between \"{instanceof(self)}\" (type={bonkType}) and \"{instanceof(_otherShape)}\" (type={_otherShape.bonkType})");
                }
            }
        }
        
        return (_struct == undefined)? _nullCollisionData : _struct.Null();
    }
    
    __CollideAddToArray = function(_collideArrayContainer, _otherShape, _groupFilter)
    {
        var _collide = _otherShape.Collide(self, _groupFilter, _collideArrayContainer.__collideArray[_collideArrayContainer.__count], true);
        
        if (_collide.shape != undefined)
        {
            ++_collideArrayContainer.__count;
            return _collide;
        }
        else
        {
            return undefined;
        }
    }
    
    Deflect = function(_subjectShape, _slopeThreshold = 0, _groupFilter = -1)
    {
        return __BonkConvertCollideToDeflect(_subjectShape, _slopeThreshold, _subjectShape.Collide(self, _groupFilter));
    }
    
    FilterTest = function(_filter = -1)
    {
        if (_filter < 0)
        {
            return true;
        }
        
        var _bonkGroup = bonkGroup;
        
        //Filter out shapes that conflict with the NOT vector (if in use)
        var _notVector = (_filter >> 40) & 0xFFFFF;
        if ((_notVector > 0) && (_bonkGroup & _notVector))
        {
            return false;
        }
        
        //Accept shapes that hit the OR vector
        if (_bonkGroup & (_filter & 0xFFFFF))
        {
            return true;
        }
        
        //Accept shapes the hit all of the AND vector (if in use)
        var _andVector = (_filter >> 20) & 0xFFFFF;
        if ((_andVector > 0) && ((_bonkGroup & _andVector) == _andVector))
        {
            return true;
        }
        
        return false;
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
        
        if ((_xCell < 0) || (_xCell > cellCountX-1) || (_yCell < 0) || (_yCell > cellCountY-1))
        {
            array_resize(_array, 0);
        }
        else
        {
            array_resize(_array, 2);
            array_copy(_array, 0, __bonkTriangleArray, _xCell + _yCell*cellCountX, 2);
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
        var _cellCountX = cellCountX;
        var _cellCountY = cellCountY;
        
        var _xShape = x;
        var _yShape = y;
        
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
        
        if ((_xMin > _cellCountX-1) || (_yMin > _cellCountY-1) || (_xMax < 0) || (_yMax < 0))
        {
            //Range is outside bounds
            return;
        }
        
        _xMin = clamp(_xMin, 0, _cellCountX-1);
        _yMin = clamp(_yMin, 0, _cellCountY-1);
        
        _xMax = clamp(_xMax, 0, _cellCountX-1);
        _yMax = clamp(_yMax, 0, _cellCountY-1);
        
        var _cellCheckWidth = 2*(1 + _xMax - _xMin);
        
        //FIXME - Apply transformation matrix here to move the shapes
        
        var _y = _yMin;
        repeat(1 + _yMax - _yMin)
        {
            var _index = 2*(_xMin + _cellCountX*_y);
            repeat(2*_cellCheckWidth)
            {
                _bonkTriangleArray[_index++].DebugDraw(_color, _wireframe);
            }
            
            ++_y;
        }
    }
    
    DrawShapesFromArray = function(_array, _color = undefined, _wireframe = undefined)
    {
        var _xShape = x;
        var _yShape = y;
        var _zShape = z;
        
        var _cellCountX = cellCountX;
        var _cellCountY = cellCountY;
        
        var _xScale = xScale;
        var _yScale = yScale;
        
        var _zMin = _zShape + __bonkMinZ;
        var _zMax = _zShape + __bonkMaxZ;
        
        var _bonkTriangleArray = __bonkTriangleArray;
        
        __BonkSetWorldMatrix(x, y, z);
        
        var _i = 0;
        repeat(array_length(_array) div 3)
        {
            var _z = _array[_i+2];
            if ((_z >= _zMin) && (_z <= _zMax))
            {
                var _xCell = floor((_array[_i  ] - _xShape) / _xScale);
                var _yCell = floor((_array[_i+1] - _yShape) / _yScale);
                
                if ((_xCell >= 0) && (_yCell >= 0) && (_xCell <= _cellCountX-1) && (_yCell <= _cellCountY-1))
                {
                    var _index = 2*(_xCell + _cellCountX*_yCell);
                    _bonkTriangleArray[_index  ].DebugDraw(_color, _wireframe);
                    _bonkTriangleArray[_index+1].DebugDraw(_color, _wireframe);
                }
            }
            
            ++_i;
        }
        
        __BonkResetWorldMatrix();
    }
    
    DrawShapes = function(_color = undefined, _wireframe = undefined)
    {
        __BonkSetWorldMatrix(x, y, z);
        
        var _bonkTriangleArray = __bonkTriangleArray;
        var _i = 0;
        repeat(array_length(_bonkTriangleArray))
        {
            _bonkTriangleArray[_i].DebugDraw(_color, _wireframe);
            ++_i;
        }
        
        __BonkResetWorldMatrix();
    }
    
    DebugDraw = function(_color = undefined, _wireframe = undefined)
    {
        var _density = 5;
        
        var _xScale = xScale;
        var _yScale = yScale;
        var _zScale = zScale;
        
        var _incrX = _xScale / _density;
        var _incrY = _yScale / _density;
        
        var _worldY = y;
        repeat(_density*cellCountY + 1)
        {
            var _worldX = x;
            repeat(_density*cellCountX + 1)
            {
                UggPoint(_worldX, _worldY, GetZ(_worldX, _worldY));
                
                //DrawSurface(x + _worldX,           y + _worldY,
                //            x + _worldX + _xScale, y + _worldY + _yScale,
                //            z + _zScale*_heightFunction(_cellX, _cellY  ), z + _zScale*_heightFunction(_cellX+1, _cellY  ),
                //            z + _zScale*_heightFunction(_cellX, _cellY+1), z + _zScale*_heightFunction(_cellX+1, _cellY+1),
                //            7);
                
                _worldX += _incrX;
            }
            
            _worldY += _incrY;
        }
    }
    
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
    //    repeat(_subdivision*(cellCountY-1) + 1)
    //    {
    //        var _xWorld = _x;
    //        var _xCell = 0;
    //        repeat(_subdivision*(cellCountX-1) + 1)
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
        var _xShape = x;
        var _yShape = y;
        var _zShape = z + 0.5*zScale;
        
        var _cellCountX = cellCountX;
        var _cellCountY = cellCountY;
        
        var _xScale = xScale;
        var _yScale = yScale;
        var _zScale = zScale;
        
        var _i = 0;
        repeat(array_length(_array) div 2)
        {
            var _x = floor(_array[_i  ]);
            var _y = floor(_array[_i+1]);
            
            if ((_x >= 0) && (_y >= 0) && (_x <= _cellCountX-1) && (_y <= _cellCountY-1))
            {
                UggAABB(_xShape + _xScale*(_x + 0.5),
                        _yShape + _yScale*(_y + 0.5),
                        _zShape,
                        _xScale, _yScale, _zScale,
                        _color, _wireframe);
            }
            
            _i += 2;
        }
    }
    
    DrawCellsFromRange = function(_struct, _color = undefined, _wireframe = true, _checkerboard = false)
    {
        var _xShape = x;
        var _yShape = y;
        var _zShape = z;
        
        var _cellCountX = cellCountX;
        var _cellCountY = cellCountY;
        
        var _xScale = xScale;
        var _yScale = yScale;
        var _zScale = zScale;
        
        if ((_struct.zMin > _zShape + __bonkMaxZ) || (_struct.zMax < _zShape + __bonkMinZ))
        {
            return;
        }
        
        var _xMin = floor((_struct.xMin - _xShape) / xScale);
        var _yMin = floor((_struct.yMin - _yShape) / yScale);
        
        var _xMax = floor((_struct.xMax - _xShape) / xScale);
        var _yMax = floor((_struct.yMax - _yShape) / yScale);
        
        if ((_xMin > _cellCountX-1) || (_yMin > _cellCountY-1) || (_xMax < 0) || (_yMax < 0))
        {
            //Range is outside bounds
            return;
        }
        
        _xMin = clamp(_xMin, 0, _cellCountX-1);
        _yMin = clamp(_yMin, 0, _cellCountY-1);
        
        _xMax = clamp(_xMax, 0, _cellCountX-1);
        _yMax = clamp(_yMax, 0, _cellCountY-1);
        
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
        return __GetCellsFromLineExtInternal(_x1-x, _y1-y, _z1-z, _x2-x, _y2-y, _z2-z);
    }
    
    __GetCellsFromLineExtInternal = function(_x1, _y1, _z1, _x2, _y2, _z2)
    {
        //FIXME - Return a static array
        
        var _dX = _x2 - _x1;
        var _dY = _y2 - _y1;
        var _dZ = _z2 - _z1;
        
        //xMin and yMin are both 0
        var _zMin = __bonkMinZ;
        
        var _xMax = __bonkWidth;
        var _yMax = __bonkHeight;
        var _zMax = __bonkMaxZ;
        
        if (_dX == 0)
        {
            var _t1 = -infinity;
            var _t2 =  infinity;
        }
        else
        {
            var _t1 = -_x1 / _dX;
            var _t2 = (_xMax - _x1) / _dX;
        }
        
        if (_dY == 0)
        {
            var _t3 = -infinity;
            var _t4 =  infinity;
        }
        else
        {
            var _t3 = -_y1 / _dY;
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
        if ((_hitX < 0) || (_hitX > _xMax))
        {
            return [];
        }
        
        var _hitY = _y1 + _t*_dY;
        if ((_hitY < 0) || (_hitY > _yMax))
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