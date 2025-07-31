// Feather disable all

/// Turns Ugg's shaders on and off. Disabling Ugg's shaders allows you to use your own in their
/// place. This function will do nothing if `UGG_FORCE_USE_SHADERS` is set to something other than
/// `undefined`.
/// 
/// N.B. Disabling shaders will also disable Ugg's basic system.
/// 
/// @param state

function UggSetUseShaders(_state)
{
    __UGG_GLOBAL
    _global.__useShaders = _state;
}