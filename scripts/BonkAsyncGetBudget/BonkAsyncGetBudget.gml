// Feather disable all

/// Returns the amount of time per Step that Bonk is allowed to use to process async operations.

function BonkAsyncGetBudget()
{
    static _system = __BonkSystem();
    
    return _system.__asyncBudget;
}