#macro __BONK_VERIFY_UGG  static _uggPresent = __Bonk().__uggPresent;\
                          if (not _uggPresent)\
                          {\
                              __BonkError("Cannot draw shape, Ugg has not been imported to your project\nPlease visit https://www.github.com/jujuadams/Ugg/");\
                          }

show_debug_message("Welcome to Bonk by Juju Adams! This is version " + BONK_VERSION + " " + BONK_DATE);



__Bonk();
function __Bonk()
{
    static _global = undefined;
    if (_global != undefined) return _global;
    
    _global = {};
    with(_global)
    {
        __nullCollisionData = new __BonkClassCollideData();
        __nullCollisionData.collision = false;
        
        __nullDeflectData = new __BonkClassDeflectData();
        
        __nullHit = new __BonkClassHit();
        __nullHit.collision = false;
        
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