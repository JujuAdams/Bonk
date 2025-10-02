shape = BonkInstCapsule(x, y, 200,   80, 25);
velocity = new BonkVelocity();

line = new BonkLine(shape.x, shape.y, shape.z + 0.5*shape.height,
                    shape.x, shape.y, shape.z - 0.5*shape.height - 50);

gravAccel = 0.1;
onGroundFrames = 0;