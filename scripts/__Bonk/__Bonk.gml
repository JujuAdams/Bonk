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
        
        __collideFuncLookup = array_create_ext(BONK_NUMBER_OF_TYPES, function()
        {
            return array_create(BONK_NUMBER_OF_TYPES, undefined);
        });
        
        __collideFuncLookup[BONK_TYPE_AABB][BONK_TYPE_AABB        ] = BonkAABBInAABB;
        __collideFuncLookup[BONK_TYPE_AABB][BONK_TYPE_CAPSULE     ] = BonkAABBInCapsule;
        __collideFuncLookup[BONK_TYPE_AABB][BONK_TYPE_CYLINDER    ] = BonkAABBInCylinder;
        __collideFuncLookup[BONK_TYPE_AABB][BONK_TYPE_CYLINDER_EXT] = BonkAABBInCylinder;
        __collideFuncLookup[BONK_TYPE_AABB][BONK_TYPE_LINE        ] = undefined;
        __collideFuncLookup[BONK_TYPE_AABB][BONK_TYPE_RAY         ] = undefined;
        __collideFuncLookup[BONK_TYPE_AABB][BONK_TYPE_POINT       ] = undefined;
        __collideFuncLookup[BONK_TYPE_AABB][BONK_TYPE_QUAD        ] = undefined;
        __collideFuncLookup[BONK_TYPE_AABB][BONK_TYPE_SPHERE      ] = BonkAABBInSphere;
        __collideFuncLookup[BONK_TYPE_AABB][BONK_TYPE_TRIANGLE    ] = undefined;
        
        __collideFuncLookup[BONK_TYPE_CAPSULE][BONK_TYPE_AABB        ] = BonkCapsuleInAABB;
        __collideFuncLookup[BONK_TYPE_CAPSULE][BONK_TYPE_CAPSULE     ] = BonkCapsuleInCapsule;
        __collideFuncLookup[BONK_TYPE_CAPSULE][BONK_TYPE_CYLINDER    ] = BonkCapsuleInCylinder;
        __collideFuncLookup[BONK_TYPE_CAPSULE][BONK_TYPE_CYLINDER_EXT] = BonkCapsuleInCylinder;
        __collideFuncLookup[BONK_TYPE_CAPSULE][BONK_TYPE_LINE        ] = undefined;
        __collideFuncLookup[BONK_TYPE_CAPSULE][BONK_TYPE_RAY         ] = undefined;
        __collideFuncLookup[BONK_TYPE_CAPSULE][BONK_TYPE_POINT       ] = undefined;
        __collideFuncLookup[BONK_TYPE_CAPSULE][BONK_TYPE_QUAD        ] = BonkCapsuleInQuad;
        __collideFuncLookup[BONK_TYPE_CAPSULE][BONK_TYPE_SPHERE      ] = BonkCapsuleInSphere;
        __collideFuncLookup[BONK_TYPE_CAPSULE][BONK_TYPE_TRIANGLE    ] = BonkCapsuleInTriangle;
        
        __collideFuncLookup[BONK_TYPE_CYLINDER][BONK_TYPE_AABB        ] = BonkCylinderInAABB;
        __collideFuncLookup[BONK_TYPE_CYLINDER][BONK_TYPE_CAPSULE     ] = undefined;
        __collideFuncLookup[BONK_TYPE_CYLINDER][BONK_TYPE_CYLINDER    ] = BonkCylinderInCylinder;
        __collideFuncLookup[BONK_TYPE_CYLINDER][BONK_TYPE_CYLINDER_EXT] = BonkCylinderInCylinder;
        __collideFuncLookup[BONK_TYPE_CYLINDER][BONK_TYPE_LINE        ] = undefined;
        __collideFuncLookup[BONK_TYPE_CYLINDER][BONK_TYPE_RAY         ] = undefined;
        __collideFuncLookup[BONK_TYPE_CYLINDER][BONK_TYPE_POINT       ] = undefined;
        __collideFuncLookup[BONK_TYPE_CYLINDER][BONK_TYPE_QUAD        ] = undefined;
        __collideFuncLookup[BONK_TYPE_CYLINDER][BONK_TYPE_SPHERE      ] = BonkCylinderInSphere;
        __collideFuncLookup[BONK_TYPE_CYLINDER][BONK_TYPE_TRIANGLE    ] = undefined;
        
        __collideFuncLookup[BONK_TYPE_CYLINDER_EXT][BONK_TYPE_AABB        ] = BonkCylinderInAABB;
        __collideFuncLookup[BONK_TYPE_CYLINDER_EXT][BONK_TYPE_CAPSULE     ] = BonkCylinderInCapsule;
        __collideFuncLookup[BONK_TYPE_CYLINDER_EXT][BONK_TYPE_CYLINDER    ] = BonkCylinderInCylinder;
        __collideFuncLookup[BONK_TYPE_CYLINDER_EXT][BONK_TYPE_CYLINDER_EXT] = BonkCylinderInCylinder;
        __collideFuncLookup[BONK_TYPE_CYLINDER_EXT][BONK_TYPE_LINE        ] = undefined;
        __collideFuncLookup[BONK_TYPE_CYLINDER_EXT][BONK_TYPE_RAY         ] = undefined;
        __collideFuncLookup[BONK_TYPE_CYLINDER_EXT][BONK_TYPE_POINT       ] = undefined;
        __collideFuncLookup[BONK_TYPE_CYLINDER_EXT][BONK_TYPE_QUAD        ] = BonkCapsuleInQuad;
        __collideFuncLookup[BONK_TYPE_CYLINDER_EXT][BONK_TYPE_SPHERE      ] = BonkCylinderInSphere;
        __collideFuncLookup[BONK_TYPE_CYLINDER_EXT][BONK_TYPE_TRIANGLE    ] = BonkCapsuleInTriangle;
        
        __collideFuncLookup[BONK_TYPE_LINE][BONK_TYPE_AABB        ] = undefined;
        __collideFuncLookup[BONK_TYPE_LINE][BONK_TYPE_CAPSULE     ] = undefined;
        __collideFuncLookup[BONK_TYPE_LINE][BONK_TYPE_CYLINDER    ] = undefined;
        __collideFuncLookup[BONK_TYPE_LINE][BONK_TYPE_CYLINDER_EXT] = undefined;
        __collideFuncLookup[BONK_TYPE_LINE][BONK_TYPE_LINE        ] = undefined;
        __collideFuncLookup[BONK_TYPE_LINE][BONK_TYPE_RAY         ] = undefined;
        __collideFuncLookup[BONK_TYPE_LINE][BONK_TYPE_POINT       ] = undefined;
        __collideFuncLookup[BONK_TYPE_LINE][BONK_TYPE_QUAD        ] = undefined;
        __collideFuncLookup[BONK_TYPE_LINE][BONK_TYPE_SPHERE      ] = undefined;
        __collideFuncLookup[BONK_TYPE_LINE][BONK_TYPE_TRIANGLE    ] = undefined;
        
        __collideFuncLookup[BONK_TYPE_RAY][BONK_TYPE_AABB        ] = undefined;
        __collideFuncLookup[BONK_TYPE_RAY][BONK_TYPE_CAPSULE     ] = undefined;
        __collideFuncLookup[BONK_TYPE_RAY][BONK_TYPE_CYLINDER    ] = undefined;
        __collideFuncLookup[BONK_TYPE_RAY][BONK_TYPE_CYLINDER_EXT] = undefined;
        __collideFuncLookup[BONK_TYPE_RAY][BONK_TYPE_LINE        ] = undefined;
        __collideFuncLookup[BONK_TYPE_RAY][BONK_TYPE_RAY         ] = undefined;
        __collideFuncLookup[BONK_TYPE_RAY][BONK_TYPE_POINT       ] = undefined;
        __collideFuncLookup[BONK_TYPE_RAY][BONK_TYPE_QUAD        ] = undefined;
        __collideFuncLookup[BONK_TYPE_RAY][BONK_TYPE_SPHERE      ] = undefined;
        __collideFuncLookup[BONK_TYPE_RAY][BONK_TYPE_TRIANGLE    ] = undefined;
        
        __collideFuncLookup[BONK_TYPE_POINT][BONK_TYPE_AABB        ] = undefined;
        __collideFuncLookup[BONK_TYPE_POINT][BONK_TYPE_CAPSULE     ] = undefined;
        __collideFuncLookup[BONK_TYPE_POINT][BONK_TYPE_CYLINDER    ] = undefined;
        __collideFuncLookup[BONK_TYPE_POINT][BONK_TYPE_CYLINDER_EXT] = undefined;
        __collideFuncLookup[BONK_TYPE_POINT][BONK_TYPE_LINE        ] = undefined;
        __collideFuncLookup[BONK_TYPE_POINT][BONK_TYPE_RAY         ] = undefined;
        __collideFuncLookup[BONK_TYPE_POINT][BONK_TYPE_POINT       ] = undefined;
        __collideFuncLookup[BONK_TYPE_POINT][BONK_TYPE_QUAD        ] = undefined;
        __collideFuncLookup[BONK_TYPE_POINT][BONK_TYPE_SPHERE      ] = undefined;
        __collideFuncLookup[BONK_TYPE_POINT][BONK_TYPE_TRIANGLE    ] = undefined;
        
        __collideFuncLookup[BONK_TYPE_QUAD][BONK_TYPE_AABB        ] = undefined;
        __collideFuncLookup[BONK_TYPE_QUAD][BONK_TYPE_CAPSULE     ] = BonkQuadInCapsule;
        __collideFuncLookup[BONK_TYPE_QUAD][BONK_TYPE_CYLINDER    ] = undefined;
        __collideFuncLookup[BONK_TYPE_QUAD][BONK_TYPE_CYLINDER_EXT] = BonkQuadInCapsule;
        __collideFuncLookup[BONK_TYPE_QUAD][BONK_TYPE_LINE        ] = undefined;
        __collideFuncLookup[BONK_TYPE_QUAD][BONK_TYPE_RAY         ] = undefined;
        __collideFuncLookup[BONK_TYPE_QUAD][BONK_TYPE_POINT       ] = undefined;
        __collideFuncLookup[BONK_TYPE_QUAD][BONK_TYPE_QUAD        ] = undefined;
        __collideFuncLookup[BONK_TYPE_QUAD][BONK_TYPE_SPHERE      ] = BonkQuadInSphere;
        __collideFuncLookup[BONK_TYPE_QUAD][BONK_TYPE_TRIANGLE    ] = undefined;
        
        __collideFuncLookup[BONK_TYPE_SPHERE][BONK_TYPE_AABB        ] = BonkSphereInAABB;
        __collideFuncLookup[BONK_TYPE_SPHERE][BONK_TYPE_CAPSULE     ] = BonkSphereInCapsule;
        __collideFuncLookup[BONK_TYPE_SPHERE][BONK_TYPE_CYLINDER    ] = BonkSphereInCylinder;
        __collideFuncLookup[BONK_TYPE_SPHERE][BONK_TYPE_CYLINDER_EXT] = BonkSphereInCylinder;
        __collideFuncLookup[BONK_TYPE_SPHERE][BONK_TYPE_LINE        ] = undefined;
        __collideFuncLookup[BONK_TYPE_SPHERE][BONK_TYPE_RAY         ] = undefined;
        __collideFuncLookup[BONK_TYPE_SPHERE][BONK_TYPE_POINT       ] = undefined;
        __collideFuncLookup[BONK_TYPE_SPHERE][BONK_TYPE_QUAD        ] = BonkSphereInQuad;
        __collideFuncLookup[BONK_TYPE_SPHERE][BONK_TYPE_SPHERE      ] = BonkSphereInSphere;
        __collideFuncLookup[BONK_TYPE_SPHERE][BONK_TYPE_TRIANGLE    ] = BonkSphereInTriangle;
        
        __collideFuncLookup[BONK_TYPE_TRIANGLE][BONK_TYPE_AABB        ] = undefined;
        __collideFuncLookup[BONK_TYPE_TRIANGLE][BONK_TYPE_CAPSULE     ] = BonkTriangleInCapsule;
        __collideFuncLookup[BONK_TYPE_TRIANGLE][BONK_TYPE_CYLINDER    ] = undefined;
        __collideFuncLookup[BONK_TYPE_TRIANGLE][BONK_TYPE_CYLINDER_EXT] = BonkTriangleInCapsule;
        __collideFuncLookup[BONK_TYPE_TRIANGLE][BONK_TYPE_LINE        ] = undefined;
        __collideFuncLookup[BONK_TYPE_TRIANGLE][BONK_TYPE_RAY         ] = undefined;
        __collideFuncLookup[BONK_TYPE_TRIANGLE][BONK_TYPE_POINT       ] = undefined;
        __collideFuncLookup[BONK_TYPE_TRIANGLE][BONK_TYPE_QUAD        ] = undefined;
        __collideFuncLookup[BONK_TYPE_TRIANGLE][BONK_TYPE_SPHERE      ] = BonkTriangleInSphere;
        __collideFuncLookup[BONK_TYPE_TRIANGLE][BONK_TYPE_TRIANGLE    ] = undefined;
    }
    
    return _global;
}