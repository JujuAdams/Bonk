aabb = new BonkAABB().SetPosition(200, 200, 0).SetSize(50, 100, 150);

lineArray = [
    new BonkLine().SetA(0, 200, 0).SetB(200, 200, -100),
    new BonkLine().SetA(0, 220, 0).SetB(200, 200,    0),
    new BonkLine().SetLine(0, 220, 0, 400, -20, 100),
    new BonkLine().SetA(0, 260, 0).SetB(200, 250,  -20),
    new BonkLine().SetA(0, 280, 0).SetB(200, 200,  100),
];