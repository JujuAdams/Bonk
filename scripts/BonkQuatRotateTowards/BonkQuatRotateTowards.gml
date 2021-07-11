/// @param quaternion
/// @param x
/// @param y
/// @param z
/// @param step

function BonkQuatRotateTowards(_quat, _x, _y, _z, _step)
{
    var _angle = BonkQuatAngleTo(_quat, _x, _y, _z);
    if (_angle == 0) return BonkQuatDuplicate(_quat);
    
    var _t = min(1, _step/_angle);
    return BonkQuatSlerp(_quat, [_x, _y, _z, 0], _t);
}