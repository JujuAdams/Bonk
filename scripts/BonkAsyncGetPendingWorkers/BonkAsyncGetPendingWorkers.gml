// Feather disable all

/// Returns the number of pending asynchronous workers.
//// 
/// If the optional `smooth` parameter is set to `true` then this value can return a decimal
/// value. For example, if there are three workers and the first worker is 40% complete then this
/// function will return `2.6`: there are two workers that haven't been started and the first
/// worker has 60% of its content left to process.
/// 
/// @param [smooth=false]

function BonkAsyncGetPendingWorkers(_smooth = false)
{
    static _pendingWorkerArray = __BonkSystem().__pendingWorkerArray;
    
    var _count = array_length(_pendingWorkerArray);
    
    if (not _smooth)
    {
        return _count;
    }
    
    if (_count <= 0)
    {
        return 0;
    }
    
    return (_count - _pendingWorkerArray[0].GetProgress());
}