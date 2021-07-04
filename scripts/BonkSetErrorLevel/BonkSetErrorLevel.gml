/// Determines Bonk's behaviour when encountering a recoverable error
/// 
/// Three values are supported:
/// 0: No warnings or errors
/// 1: Recoverable issues will be outputted to the debug log
/// 2: Recoverable issues will result in an error
/// 
/// @param level   Error level to set (see above)

function BonkSetErrorLevel(_level = BONK_DEFAULT_ERROR_LEVEL)
{
    global.__bonkErrorLevel = _level;
}