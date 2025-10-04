// Whether to check for strict collision compatibility.
#macro BONK_STRICT  true

// Default group vector to set for new Bonk structs/instances.
#macro BONK_DEFAULT_GROUP  0x01

// Default length of rays. Rays are actually very long lines!
#macro BONK_RAY_LENGTH  100_000

// Adds callstack data to Bonk instances in the `bonkCreateCallstack` variable. This is helpful
// when tracking down Bonk instances that haven't been destroyed when they should be.
#macro BONK_DEBUG_INSTANCES  false

// Adds callstack data to Bonk structs in the `bonkCreateCallstack` variable. This is helpful
// when tracking down why Bonk structs have been created.
#macro BONK_DEBUG_STRUCTS  false