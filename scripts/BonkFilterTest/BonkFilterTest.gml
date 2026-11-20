// Feather disable all

/// @param group
/// @param groupFilter

function BonkFilterTest(_bonkGroup, _filter)
{
    if ((_filter == undefined) || (_filter == 0x00) || (_bonkGroup == undefined))
    {
        return true;
    }
    
    //Filter out shapes that conflict with the NOT vector (if in use)
    var _notVector = (_filter >> 40) & 0xFFFFF;
    if ((_notVector > 0) && (_bonkGroup & _notVector))
    {
        return false;
    }
    
    //Accept shapes that hit the OR vector
    if (_bonkGroup & (_filter & 0xFFFFF))
    {
        return true;
    }
    
    //Accept shapes the hit all of the AND vector (if in use)
    var _andVector = (_filter >> 20) & 0xFFFFF;
    if ((_andVector > 0) && ((_bonkGroup & _andVector) == _andVector))
    {
        return true;
    }
    
    return false;
}