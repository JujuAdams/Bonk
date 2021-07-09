//Reset draw state
matrix_set(matrix_world,      old_world     );
matrix_set(matrix_view,       old_view      );
matrix_set(matrix_projection, old_projection);

gpu_set_ztestenable(false);
gpu_set_zwriteenable(false);
gpu_set_cullmode(cull_noculling);