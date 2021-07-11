function BonkQuatRotateLocalZ(_quat, _angle)
{
    return BonkQuatMultiply([0, 0, 0.5*dsin(_angle), dcos(0.5*_angle)], _quat);
}