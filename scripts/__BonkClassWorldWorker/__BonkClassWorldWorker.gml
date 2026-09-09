// Feather disable all

/// @param world
/// @param vertexbufferArray
/// @param vertexFormat
/// @param matrix
/// @param applySoftEdges

function __BonkClassWorldWorker(_world, _vertexBufferArray, _vertexFormat, _matrix, _applySoftEdges) constructor
{
    static _pendingWorkerArray = __BonkSystem().__pendingWorkerArray;
    
    if (BONK_DEBUG_VERTEX_BUFFER_ASYNC)
    {
        __BonkTrace($"Adding worker {string(ptr(self))} to world {string(ptr(_world))}");
    }
    
    __world             = _world;
    __vertexBufferArray = _vertexBufferArray;
    __vertexFormat      = _vertexFormat;
    __matrix            = _matrix;
    __applySoftEdges    = _applySoftEdges;
    
    array_push(__world.__bonkWorkerArray, self);
    
    __finished   = false;
    __timeSource = undefined;
    
    __buffer = undefined;
    __vertexBufferIndex = undefined;
    __vertexFormatStride = undefined;
    __vertexFormatPositionOffset = undefined;
    __triangleCount = undefined;
    __trianglesRemaining = undefined;
    
    __edgeMap = ds_map_create();
    
    
    
    static GetFinished = function()
    {
        return __finished;
    }
    
    static Force = function()
    {
        while(not __finished)
        {
            __funcUpdate();
        }
    }
    
    static Cancel = function()
    {
        __End();
    }
    
    static GetRemaining = function()
    {
        if (__finished)
        {
            return 0;
        }
        
        return __trianglesRemaining ?? 0;
    }
    
    static GetProgress = function()
    {
        if (__finished)
        {
            return 1;
        }
        
        var _vertexBufferCount = array_length(__vertexBufferArray);
        var _value = (__vertexBufferIndex ?? 0) / _vertexBufferCount;
        
        if ((__triangleCount == undefined) || (__trianglesRemaining == undefined))
        {
            var _triangleProgress =  0;
        }
        else
        {
            var _triangleProgress = clamp(1 - (__trianglesRemaining / __triangleCount), 0, 1);
        }
        
        return _value + _triangleProgress/_vertexBufferCount;
    }
    
    static __End = function()
    {
        if (__finished) return;
        
        if (BONK_DEBUG_VERTEX_BUFFER_ASYNC)
        {
            __BonkTrace($"Removing worker {string(ptr(self))} from world {string(ptr(__world))}");
        }
        
        __finished = true;
        
        if (__buffer != undefined)
        {
            buffer_delete(__buffer);
            __buffer = undefined;
        }
        
        if (__timeSource != undefined)
        {
            time_source_stop(__timeSource);
            time_source_destroy(__timeSource);
            __timeSource = undefined;
        }
        
        if (__edgeMap != undefined)
        {
            ds_map_destroy(__edgeMap);
            __edgeMap = undefined;
        }
        
        var _index = array_get_index(__world.__bonkWorkerArray, self);
        if (_index >= 0)
        {
            array_delete(__world.__bonkWorkerArray, _index, 1);
        }
        else
        {
            __BonkTrace($"Warning! Could not find worker {string(ptr(self))} in world {string(ptr(__world))}");
        }
    }
    
    static __StartAsync = function()
    {
        array_push(_pendingWorkerArray, self);
        
        return self;
    }
    
    __funcUpdate = __WorkFirstTime;
    
    static __WorkFirstTime = function()
    {
        if (__finished) return true;
        
        var _vertexFormatInfo = vertex_format_get_info(__vertexFormat);
        __vertexFormatStride = _vertexFormatInfo.stride;
        
        var _elementsArray = _vertexFormatInfo.elements;
        __vertexFormatPositionOffset = undefined;
        var _i = 0;
        repeat(array_length(_elementsArray))
        {
            var _elementStruct = _elementsArray[_i];
            if ((_elementStruct.usage == vertex_usage_position) && (_elementStruct.size == 12))
            {
                __vertexFormatPositionOffset = _elementStruct.offset;
                break;
            }
            
            ++_i;
        }
        
        if (__vertexFormatPositionOffset == undefined)
        {
            __BonkError("Could not find position data in vertex format");
        }
        
        __vertexBufferIndex = 0;
        
        __funcUpdate = __WorkVertexBuffer;
        
        return false;
    }
    
    static __WorkVertexBuffer = function()
    {
        if (__finished) return true;
        
        var _vertexBuffer = __vertexBufferArray[__vertexBufferIndex];
        
        var _vertexCount = vertex_get_number(_vertexBuffer);
        __triangleCount = _vertexCount / 3;
        if (__triangleCount != floor(__triangleCount))
        {
            __BonkError($"Vertex buffer does not have a whole number of triangles (vertex count {_vertexCount} is not divisible by 3)");
        }
        
        __trianglesRemaining = __triangleCount;
        
        __buffer = buffer_create_from_vertex_buffer_ext(_vertexBuffer, buffer_fixed, 1, 0, _vertexCount);
        buffer_seek(__buffer, buffer_seek_start, __vertexFormatPositionOffset);
        
        __funcUpdate = __WorkTriangles;
        
        return false;
    }
        
    static __WorkTriangles = function()
    {
        if (__finished) return true;
        
        var _applySoftEdges = __applySoftEdges;
        var _edgeMap = __edgeMap;
        
        var _funcEdgeCheck = method(undefined, function(_edgeMap, _x1, _y1, _z1, _x2, _y2, _z2, _edgeIndex, _flip)
        {
            var _edgeKey = $"{_x1},{_y1},{_z1}->{_x2},{_y2},{_z2}"; //TODO - Buffer might be faster
            
            var _otherArray = _edgeMap[? _edgeKey];
            if (_otherArray == undefined)
            {
                //Use an array for storing edge information as it uses less memory than a struct
                _edgeMap[? _edgeKey] = [self, _edgeIndex, normalX, normalY, normalZ];
            }
            else
            {
                var _other = _otherArray[0];
                if (_other != self)
                {
                    var _normalX = normalX;
                    var _normalY = normalY;
                    var _normalZ = normalZ;
                    
                    var _otherNormalX = _otherArray[2];
                    var _otherNormalY = _otherArray[3];
                    var _otherNormalZ = _otherArray[4];
                    
                    //Calculate the dot product between the two normals. If the normals are close to each other then this is
                    //always a soft edge
                    var _dotAngle = dot_product_3d(_normalX, _normalY, _normalZ, _otherNormalX, _otherNormalY, _otherNormalZ);
                    
                    if (_dotAngle < 0.98)
                    {
                        //Calculate the dot product between the edge itself and the cross product of the two normals
                        //This will detect if the two faces meet as a valley or a peak. We always want valleys to be
                        //soft edges. This dot product will be negative if the two normals point away from each other
                        //which indicates a peak
                        if (_flip*dot_product_3d(_x2 - _x1, _y2 - _y1, _z2 - _z1,
                                                 _normalZ*_otherNormalY - _normalY*_otherNormalZ,
                                                 _normalX*_otherNormalZ - _normalZ*_otherNormalX,
                                                 _normalY*_otherNormalX - _normalX*_otherNormalY) >= 0)
                        {
                            _dotAngle = 1;
                        }
                    }
                    
                    if (_dotAngle >= 0.98)
                    {
                        //Mark our edge as soft
                        if (_edgeIndex == 1)
                        {
                            hardEdge12 = false;
                        }
                        else if (_edgeIndex == 2)
                        {
                            hardEdge23 = false;
                        }
                        else if (_edgeIndex == 3)
                        {
                            hardEdge31 = false;
                        }
                        
                        //Mark the other edge as soft
                        var _otherEdgeIndex = _otherArray[1];
                        if (_otherEdgeIndex == 1)
                        {
                            _other.hardEdge12 = false;
                        }
                        else if (_otherEdgeIndex == 2)
                        {
                            _other.hardEdge23 = false;
                        }
                        else if (_otherEdgeIndex == 3)
                        {
                            _other.hardEdge31 = false;
                        }
                    }
                }
            }
        });
        
        var _world              = __world;
        var _buffer             = __buffer;
        var _vertexFormatStride = __vertexFormatStride;
        var _matrix             = __matrix;
        
        repeat(min(BONK_VERTEX_BUFFER_ASYNC_TRIANGLE_RESOLUTION, __trianglesRemaining))
        {
            var _x1 = buffer_read(_buffer, buffer_f32);
            var _y1 = buffer_read(_buffer, buffer_f32);
            var _z1 = buffer_read(_buffer, buffer_f32);
            
            buffer_seek(_buffer, buffer_seek_relative, _vertexFormatStride - 12);
            
            var _x2 = buffer_read(_buffer, buffer_f32);
            var _y2 = buffer_read(_buffer, buffer_f32);
            var _z2 = buffer_read(_buffer, buffer_f32);
            
            buffer_seek(_buffer, buffer_seek_relative, _vertexFormatStride - 12);
            
            var _x3 = buffer_read(_buffer, buffer_f32);
            var _y3 = buffer_read(_buffer, buffer_f32);
            var _z3 = buffer_read(_buffer, buffer_f32);
            
            buffer_seek(_buffer, buffer_seek_relative, _vertexFormatStride - 12);
            
            if (_matrix != undefined)
            {
                var _a = matrix_transform_vertex(_matrix, _x1, _y1, _z1, 1);
                var _b = matrix_transform_vertex(_matrix, _x2, _y2, _z2, 1);
                var _c = matrix_transform_vertex(_matrix, _x3, _y3, _z3, 1);
                
                _x1 = _a[0]; _y1 = _a[1]; _z1 = _a[2];
                _x2 = _b[0]; _y2 = _b[1]; _z2 = _b[2];
                _x3 = _c[0]; _y3 = _c[1]; _z3 = _c[2];
            }
            
            var _bonkTri = new BonkStructTriangle(_x1, _y1, _z1,
                                                  _x2, _y2, _z2,
                                                  _x3, _y3, _z3);
            
            if (_applySoftEdges)
            {
                with(_bonkTri)
                {
                    _funcEdgeCheck(_edgeMap,   _x1, _y1, _z1,   _x2, _y2, _z2,   1, 1);
                    _funcEdgeCheck(_edgeMap,   _x2, _y2, _z2,   _x3, _y3, _z3,   2, 1);
                    _funcEdgeCheck(_edgeMap,   _x3, _y3, _z3,   _x1, _y1, _z1,   3, 1);
                    
                    //Reverse edges
                    _funcEdgeCheck(_edgeMap,   _x2, _y2, _z2,   _x1, _y1, _z1,   1, -1);
                    _funcEdgeCheck(_edgeMap,   _x3, _y3, _z3,   _x2, _y2, _z2,   2, -1);
                    _funcEdgeCheck(_edgeMap,   _x1, _y1, _z1,   _x3, _y3, _z3,   3, -1);
                }
            }
            
            _world.__AddShape(_bonkTri); //Use the internal version to avoid unnecessary instance checks
        }
        
        __trianglesRemaining = max(0, __trianglesRemaining - BONK_VERTEX_BUFFER_ASYNC_TRIANGLE_RESOLUTION);
        
        if (__trianglesRemaining > 0)
        {
            return false;
        }
        else
        {
            buffer_delete(__buffer);
            __buffer = undefined;
            
            ++__vertexBufferIndex;
            
            if (__vertexBufferIndex >= array_length(__vertexBufferArray))
            {
                __End();
                return true;
            }
            else
            {
                __funcUpdate = __WorkVertexBuffer;
            }
        }
    }
}