pole1.Draw(BonkPoleInsideCapsule(pole1, capsule)? c_lime : c_red);
pole2.Draw(BonkPoleInsideCapsule(pole2, capsule)? c_lime : c_red);
capsule.Draw();

var _reaction = BonkPoleCollideCapsule(pole1, capsule);
if (_reaction.collision)
{
    UggLine(pole1.x + _reaction.dX,
            pole1.y + _reaction.dY,
            pole1.z + _reaction.dZ - 0.5*pole1.height,
            pole1.x + _reaction.dX,
            pole1.y + _reaction.dY,
            pole1.z + _reaction.dZ + 0.5*pole1.height,
            c_white, undefined, true);
}

var _reaction = BonkPoleCollideCapsule(pole2, capsule);
if (_reaction.collision)
{
    UggLine(pole2.x + _reaction.dX,
            pole2.y + _reaction.dY,
            pole2.z + _reaction.dZ - 0.5*pole2.height,
            pole2.x + _reaction.dX,
            pole2.y + _reaction.dY,
            pole2.z + _reaction.dZ + 0.5*pole2.height,
            c_white, undefined, true);
}