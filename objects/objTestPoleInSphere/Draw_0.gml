pole1.Draw(BonkPoleInsideSphere(pole1, sphere)? c_lime : c_red, true);
pole2.Draw(BonkPoleInsideSphere(pole2, sphere)? c_lime : c_red, true);
sphere.Draw();

var _reaction = BonkPoleCollideSphere(pole1, sphere);
if (_reaction.collision)
{
    UggLine(pole1.x + _reaction.dX,
            pole1.y + _reaction.dY,
            pole1.z + _reaction.dZ - 0.5*pole1.height,
            pole1.x + _reaction.dX,
            pole1.y + _reaction.dY,
            pole1.z + _reaction.dZ + 0.5*pole1.height);
}

var _reaction = BonkPoleCollideSphere(pole2, sphere);
if (_reaction.collision)
{
    UggLine(pole2.x + _reaction.dX,
            pole2.y + _reaction.dY,
            pole2.z + _reaction.dZ - 0.5*pole2.height,
            pole2.x + _reaction.dX,
            pole2.y + _reaction.dY,
            pole2.z + _reaction.dZ + 0.5*pole2.height);
}