#macro  __BONK_VERSION  "0.2.0"
#macro  __BONK_DATE     "2024-01-28"

#macro __BONK_VERY_LARGE  1000000

#macro __BONK_VERIFY_UGG  static _uggPresent = __Bonk().__uggPresent;\
                          if (not _uggPresent)\
                          {\
                              __BonkError("Cannot draw shape, Ugg has not been imported to your project\nPlease visit https://www.github.com/jujuadams/Ugg/");\
                          }

show_debug_message("Welcome to Bonk by Juju Adams! This is version " + __BONK_VERSION + " " + __BONK_DATE);



__Bonk();
function __Bonk()
{
    static _global = undefined;
    if (_global != undefined) return _global;
    
    _global = {};
    with(_global)
    {
        __nullReaction   = (new __BonkClassReaction()).__NoCollision();
        __nullCoordiante = (new __BonkClassCoordinate()).__NoCollision();
        
        try
        {
            __Ugg();
            __uggPresent = true;
        }
        catch(_error)
        {
            __uggPresent = false;
        }
    }
    
    return _global;
}