// Feather disable all

function __BonkTrace()
{
    var _string = "Bonk: ";
    var _i = 0;
    repeat(argument_count)
    {
        if (is_numeric(argument[_i]))
        {
            _string += string_format(argument[_i], 0, 7);
        }
        else
        {
            _string += string(argument[_i]);
        }
        
        ++_i;
    }
    
    show_debug_message(_string);
}