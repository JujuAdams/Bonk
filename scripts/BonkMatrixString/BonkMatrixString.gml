/// Returns a string containing the contents of a 4x4 matrix
/// This function gives greater decimal accuracy which is useful when dealing with real-world matrices
/// 
/// @param matrix          4x4 matrix to stringify
/// @param [newlineChar]   Character to use for each newline. If not provided, this will default to \n

function BonkMatrixString(_matrix, _newline)
{
    if (_newline == undefined) _newline = "\n";
    
    return string_format(_matrix[ 0], 2, 5) + "," + string_format(_matrix[ 1], 2, 5) + "," + string_format(_matrix[ 2], 2, 5) + "," + string_format(_matrix[ 3], 2, 5) + _newline
         + string_format(_matrix[ 4], 2, 5) + "," + string_format(_matrix[ 5], 2, 5) + "," + string_format(_matrix[ 6], 2, 5) + "," + string_format(_matrix[ 7], 2, 5) + _newline
         + string_format(_matrix[ 8], 2, 5) + "," + string_format(_matrix[ 9], 2, 5) + "," + string_format(_matrix[10], 2, 5) + "," + string_format(_matrix[11], 2, 5) + _newline
         + string_format(_matrix[12], 2, 5) + "," + string_format(_matrix[13], 2, 5) + "," + string_format(_matrix[14], 2, 5) + "," + string_format(_matrix[15], 2, 5);
}