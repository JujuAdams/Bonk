//Mouse lock variables (press F3 to lock the mouse and use mouselook)
mouse_lock = false;
mouse_lock_timer = 0;

//Some variables to track the camera
cam_x     = x;
cam_y     = y;
cam_z     = 0;
cam_yaw   = 0;
cam_pitch = 0;
cam_dx    =  dcos(cam_yaw)*dcos(cam_pitch);
cam_dy    = -dsin(cam_yaw)*dcos(cam_pitch);
cam_dz    =  dsin(cam_pitch);

//F1 toggles the info panel
show_info = true;