if (keyboard_check(ord("U"))) quaternion = BonkQuatRotateLocalX(quaternion,  0.5);
if (keyboard_check(ord("J"))) quaternion = BonkQuatRotateLocalX(quaternion, -0.5);
if (keyboard_check(ord("I"))) quaternion = BonkQuatRotateLocalY(quaternion,  0.5);
if (keyboard_check(ord("K"))) quaternion = BonkQuatRotateLocalY(quaternion, -0.5);
if (keyboard_check(ord("O"))) quaternion = BonkQuatRotateLocalZ(quaternion,  0.5);
if (keyboard_check(ord("L"))) quaternion = BonkQuatRotateLocalZ(quaternion, -0.5);