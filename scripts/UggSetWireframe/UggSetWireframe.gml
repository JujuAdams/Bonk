// Feather disable all

/// Enables or disables global wireframe drawing. This function will do nothing if
/// `UGG_FORCE_WIREFRAME` is set to something other than `undefined`.
/// 
/// @param state

function UggSetWireframe(_state)
{
    __UGG_GLOBAL
    _global.__wireframe = _state;
}