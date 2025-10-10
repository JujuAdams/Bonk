world = BonkCreateWorld(20, 20, 20, oTestInstanceParent);

BonkSetupCapsule(x, y, 200,   80, 25);
velocity = new BonkVelocity();

line = new BonkLine(x, y, z + 0.5*height,
                    x, y, z - 0.5*height - 50);

gravAccel = 0.1;
onGroundFrames = 0;