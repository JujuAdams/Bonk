// Whether to check for strict collision compatibility.
#macro BONK_STRICT  true

// Default group vector to set for new Bonk structs/instances.
#macro BONK_DEFAULT_GROUP  0x01

// Default length of rays. Rays are actually very long lines!
#macro BONK_RAY_LENGTH  100_000

// Whether to set the native GameMaker `depth` instance variable. If this macro is set to `true`,
// `depth` will be set to `z` when creating/setting up an instance and when calling an instance's
// `.SetPosition()` method.
// 
// N.B.  If you are setting `z` manually, `depth` will not be set! You should always use the
///      `.SetPosition()` method.
#macro BONK_SET_INSTANCE_DEPTH  false

// Adds callstack data to Bonk instances in the `bonkCreateCallstack` variable. This is helpful
// when tracking down Bonk instances that haven't been destroyed when they should be. Please note
// that this is an expensive feature and should be set to `false` for production builds.
#macro BONK_DEBUG_INSTANCES  false

// Adds callstack data to Bonk structs in the `bonkCreateCallstack` variable. This is helpful
// when tracking down why Bonk structs have been created. Please note that this is an expensive
// feature and should be set to `false` for production builds.
#macro BONK_DEBUG_STRUCTS  false

// Whether to output debug information when adding triangles from vertex buffers using the
// asynchronous method `AddVertexBufferAsync()`.
#macro BONK_DEBUG_VERTEX_BUFFER_ASYNC  false

// Enables debugging for the internal supercover algorithm used for line/ray hit detection against
// Bonk worlds. Setting this macro to `true` will incur a minor performance penalty and will
// provide additional information when the supercover algorithm fails.
#macro BONK_SUPERCOVER_DEBUG  true