// Feather disable all

/// Turns global wireframe drawing on and off.
/// 
/// @param state

function UggSetWireframe(_state)
{
    __UGG_GLOBAL
    _global.__wireframe = _state;
}