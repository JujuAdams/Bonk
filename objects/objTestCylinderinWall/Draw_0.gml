cylinder.Draw(BonkCylinderInsideWall(cylinder, wall)? c_lime : c_red, false);
wall.Draw(c_white, false);

var _reaction = BonkCylinderCollideWall(cylinder, wall);
if (_reaction.collision)
{
    UggCylinder(cylinder.x + _reaction.dX,
                cylinder.y + _reaction.dY,
                cylinder.z - 0.5*cylinder.height,
                cylinder.height, cylinder.radius,
                c_white, true);
}