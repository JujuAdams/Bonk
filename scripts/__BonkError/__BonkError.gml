// Feather disable all

function __BonkError()
{
    var _string = " \nBonk:\n";
    
    var _i = 0;
    repeat(argument_count)
    {
        _string += string(argument[_i]);
        ++_i;
    }
    
    show_error(_string + "\n ", true);
}