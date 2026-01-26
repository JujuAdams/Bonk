// Feather disable all

/// @param world
/// @param vertexbufferArray
/// @param vertexFormat
/// @param matrix

function __BonkClassWorker(_world, _vertexBufferArray, _vertexFormat, _matrix) constructor
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
    
    array_push(__world.__bonkWorkerArray, self);
    
    __finished   = false;
    __timeSource = undefined;
    
    __buffer = undefined;
    __vertexBufferIndex = undefined;
    __vertexFormatStride = undefined;
    __vertexFormatPositionOffset = undefined;
    __triangleCount = undefined;
    __trianglesRemaining = undefined;
    
    
    
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
                
                var _bonkTri = new BonkStructTriangle(_a[0], _a[1], _a[2],
                                                      _b[0], _b[1], _b[2],
                                                      _c[0], _c[1], _c[2]);
            }
            else
            {
                var _bonkTri = new BonkStructTriangle(_x1, _y1, _z1,
                                                      _x2, _y2, _z2,
                                                      _x3, _y3, _z3);
            }
            
            _world.__Add(_bonkTri); //Use the internal version to avoid unnecessary instance checks
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