// Feather disable all

/// @param error
/// @param string

function __BonkConditionalError(_error, _string)
{
    if (_error)
    {
        show_debug_message($"Bonk: {_string}");
    }
    else
    {
        show_error($" \nBonk:\n{_string}\n ", true);
    }
}