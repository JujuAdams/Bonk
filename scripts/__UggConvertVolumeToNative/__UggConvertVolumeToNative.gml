// Feather disable all

function __UggConvertVolumeToNative(_volume)
{
    static _nativeFormat = __Ugg().__nativeVertexFormat;
    static _volumeStride = 24;
    static _nativeStride = 36;
    
    //Data collection. I hope you clicked "Accept All" on the pop-up
    var _vertexCount = vertex_get_number(_volume);
    var _nativeBufferSize = _vertexCount*_nativeStride;
    
    //Create a new buffer to hold incoming vertex data and then null it out
    //GameMaker will sometimes leave garbage data in a buffer which I'm always wary about
    var _nativeBuffer = buffer_create(_nativeBufferSize, buffer_fixed, 1);
    buffer_fill(_nativeBuffer, 0, buffer_f32, 4, _nativeBufferSize);
    
    //Copy the position and normal information from the volume vertex buffer
    var _volumeBuffer = buffer_create_from_vertex_buffer(_volume, buffer_fixed, 1);
    buffer_copy_stride(_volumeBuffer, 0, _volumeStride, _volumeStride, _vertexCount,
                       _nativeBuffer, 0, _nativeStride);
    buffer_delete(_volumeBuffer);
    
    //Force all colors to {1,1,1,1}
    var _colorBuffer = buffer_create(4, buffer_fixed, 1);
    buffer_write(_colorBuffer, buffer_u32, 0xFFFFFFFF);
    buffer_copy_stride(_colorBuffer, 0, 4, 0, _vertexCount,
                       _nativeBuffer, 24, _nativeStride);
    buffer_delete(_colorBuffer);
    
    //Prepare the vertex buffer itself and then clean up any hanging memory
    var _volumeVertexBuffer = vertex_create_buffer_from_buffer(_nativeBuffer, _nativeFormat);
    vertex_freeze(_volumeVertexBuffer);
    buffer_delete(_nativeBuffer);
    
    return _volumeVertexBuffer;
}