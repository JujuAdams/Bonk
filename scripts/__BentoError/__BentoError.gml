// Feather disable all

function __BonkError()
{
    var _string = "Bonk: ";
    var _i = 0;
    repeat(argument_count)
    {
        _string += string(argument[_i]);
        ++_i;
    }
    
    show_debug_message(_string);
    show_error(_string + "\n ", false);
}