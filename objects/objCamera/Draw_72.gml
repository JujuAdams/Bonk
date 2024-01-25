//Turn on z-writing and z-testing so we're ready for 3D rendering
gpu_set_ztestenable(true);
gpu_set_zwriteenable(true);

//Counterclockwise faces are backfaces. We want to cull these so we're drawing less
gpu_set_cullmode(cull_counterclockwise);

//Set our view + projection matrices
oldWorldMatrix      = matrix_get(matrix_world); 
oldViewMatrix       = matrix_get(matrix_view); 
oldProjectionMatrix = matrix_get(matrix_projection);

matrix_set(matrix_view, viewMatrix);
matrix_set(matrix_projection, projectionMatrix);