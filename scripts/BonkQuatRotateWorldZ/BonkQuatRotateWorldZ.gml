function BonkQuatRotateWorldZ(_quat, _angle)
{
    return BonkQuatMultiply(_quat, [0, 0, 0.5*dsin(_angle), dcos(0.5*_angle)]);
}