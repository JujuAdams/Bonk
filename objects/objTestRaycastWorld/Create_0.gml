world = new BonkStructWorld(100, 100, 100);
world.Add(new BonkStructAAB(-200, -200, -200, 10, 10, 10));
world.Add(new BonkStructAAB( 200,  200,  200, 10, 10, 10));

line = new BonkLine(-50, 30, 50,   20, -20, -20);