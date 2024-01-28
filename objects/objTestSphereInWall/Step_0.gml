sphereA.SetPosition(lerp(0, 300, 0.5 + 0.5*dsin(current_time/20)), undefined, undefined);
sphereB.SetPosition(undefined, undefined, lerp(-100, 150, 0.5 + 0.5*dsin(current_time/10)));
sphereC.SetPosition(undefined, lerp(100, 250, 0.5 + 0.5*dsin(current_time/20)), undefined);