//Turn on z-writing and z-testing so we're ready for 3D rendering
gpu_set_ztestenable(true);
gpu_set_zwriteenable(true);

//Counterclockwise faces are backfaces. We want to cull these so we're drawing less
gpu_set_cullmode(cull_counterclockwise);

//Set our view + projection matrices
old_world      = matrix_get(matrix_world); 
old_view       = matrix_get(matrix_view); 
old_projection = matrix_get(matrix_projection);

matrix_set(matrix_view, matrix_build_lookat(cam_x, cam_y, cam_z,
                                            cam_x+cam_dx, cam_y+cam_dy, cam_z+cam_dz,
                                            0, 0, 1));
matrix_set(matrix_projection, matrix_build_projection_perspective_fov(90, room_width/room_height, 1, 3000));