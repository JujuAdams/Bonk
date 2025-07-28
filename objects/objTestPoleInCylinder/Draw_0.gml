pole.Draw(BonkPoleInsideCylinder(pole, cylinder)? c_lime : c_red, true);
cylinder.Draw(c_white, true);

var _reaction = BonkPoleCollideCylinder(pole, cylinder);
if (_reaction.collision)
{
    UggLine(pole.x + _reaction.dX,
            pole.y + _reaction.dY,
            pole.z + _reaction.dZ - 0.5*pole.height,
            pole.x + _reaction.dX,
            pole.y + _reaction.dY,
            pole.z + _reaction.dZ + 0.5*pole.height,
            c_white, undefined, true);
}