matrix = matrix_multiply(matrix_build(0,0,0,   0,0,0,   100, 1, 100), matrix_build(0,0,0,   30, 30, 45,   1,1,1));
matrix = matrix_multiply(matrix, matrix_build(x + 100*dsin(current_time/10), y, 0,   0,0,0,   1,1,1));

shape.SetMatrix(matrix);