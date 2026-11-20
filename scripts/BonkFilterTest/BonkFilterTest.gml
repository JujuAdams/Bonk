// Feather disable all

/// @param group
/// @param filter

function BonkFilterTest(_bonkGroup, _filter)
{
    if ((_filter == undefined) || (_bonkGroup == 0))
    {
        return true;
    }
    
    var _result = (_filter >= 0);
    
    //Filter out shapes that conflict with the NOT vector (if in use)
    var _notVector = (_filter >> 40) & 0xFFFFF;
    if ((_notVector > 0) && (_bonkGroup & _notVector))
    {
        return not _result;
    }
    
    //Accept shapes that hit the OR vector
    if (_bonkGroup & (_filter & 0xFFFFF))
    {
        return _result;
    }
    
    //Accept shapes the hit all of the AND vector (if in use)
    var _andVector = (_filter >> 20) & 0xFFFFF;
    if ((_andVector > 0) && ((_bonkGroup & _andVector) == _andVector))
    {
        return _result;
    }
    
    return not _result;
}