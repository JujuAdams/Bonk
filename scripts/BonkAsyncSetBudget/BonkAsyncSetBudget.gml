// Feather disable all

/// Sets the amount of time per Step that Bonk is allowed to use to process async operations. This
/// value is approximate. If no async operations are in progress then zero time will be used. The
/// asynchronous budget defaults to 2ms if not set with this function.
///
/// @param milliseconds

function BonkAsyncSetBudget(_milliseconds)
{
    static _system = __BonkSystem();
    
    _system.__asyncBudget = _milliseconds;
}