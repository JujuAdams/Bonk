pole.Draw(BonkPoleInsideAABB(pole, aabb)? c_lime : c_red, true);
aabb.Draw(c_white, true);

var _reaction = BonkPoleCollideAABB(pole, aabb);
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