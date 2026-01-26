#macro __BONK_VERIFY_UGG  static _uggPresent = __BonkSystem().__uggPresent;\
                          if (not _uggPresent)\
                          {\
                              __BonkError("Cannot draw shape, Ugg has not been imported to your project\nPlease visit https://www.github.com/jujuadams/Ugg/");\
                          }




__BonkSystem();
function __BonkSystem()
{
    static _system = undefined;
    if (_system != undefined) return _system;
    
    _system = {};
    with(_system)
    {
        __BonkTrace("Welcome to Bonk by Juju Adams! This is version " + BONK_VERSION + " " + BONK_DATE);
        
        if (BONK_RUNNING_FROM_IDE)
        {
            global.__Bonk = self;
        }
        
        __pendingWorkerArray = [];
        
        __asyncBudget = 2;
        
        try
        {
            __Ugg();
            __uggPresent = true;
            __BonkTrace("Ugg is available");
        }
        catch(_error)
        {
            __uggPresent = false;
            __BonkTrace("Ugg is unavailable");
        }
        
        time_source_start(time_source_create(time_source_global, 1, time_source_units_frames, function()
        {
            if (array_length(__pendingWorkerArray) > 0)
            {
                var _pendingWorkerArray = __pendingWorkerArray;
                
                var _elapse = current_time + __asyncBudget;
                do
                {
                    if (BONK_DEBUG_VERTEX_BUFFER_ASYNC)
                    {
                        __BonkTrace($"Worker {string(ptr(_pendingWorkerArray[0]))} updating (world {string(ptr(_pendingWorkerArray[0].__world))})");
                    }
                    
                    if (_pendingWorkerArray[0].__funcUpdate())
                    {
                        array_shift(_pendingWorkerArray);
                        if (array_length(_pendingWorkerArray) <= 0)
                        {
                            break;
                        }
                    }
                }
                until(current_time >= _elapse)
            }
        }, 
        [], -1));
    }
    
    return _system;
}