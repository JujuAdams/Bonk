sphereA = new BonkSphere().SetRadius(100).SetPosition(room_width/2, room_height/2, 0);
sphereB = new BonkSphere().SetRadius(50);

aabbA = new BonkAABB().SetPosition(room_width/2, room_height/2, 0).SetSize(200, 100, 200);
aabbB = new BonkAABB().SetPosition(0, 0, 0).SetSize(100, 200, 200);

point = new BonkPoint().SetPosition(0, 0, 0);
ray = new BonkRay().SetA(10, 10, 0).SetB(20, 20, 0);

plane = new BonkPlane().SetPosition(room_width/2, room_height/2, 0).SetNormal(0, 0, -1);