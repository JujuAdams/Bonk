// Feather disable all

function ClassCamera() constructor
{
    x = 0;
    y = 0;
    z = 0;
    
    yaw   = 0;
    pitch = 0;
    
    fieldOfView = 90;
    aspectRatio = surface_get_width(application_surface) / surface_get_height(application_surface);
    zNear       = 1;
    zFar        = 16_000;
    
    __mouseLock         = false;
    __mouseLockTimer    = 0;
    __mouseSensitivityX = 0.1;
    __mouseSensitivityY = 0.1;
    
    with({})
    {
        __cameraWeakRef = weak_ref_create(other);
        
        __timeSource = time_source_create(time_source_global, 1, time_source_units_frames, function()
        {
            if (not weak_ref_alive(__cameraWeakRef))
            {
                time_source_destroy(__timeSource);
                return;
            }
            
            with(__cameraWeakRef.ref)
            {
                //If we've got the mouse locked...
                if (__mouseLock)
                {
                    //Figure out where the centre of the window is
                    var _centreX = window_get_width()/2;
                    var _centreY = window_get_height()/2;
                    
                    //Increment a timer. Once that timer reaches 5, start pitching/panning the camera
                    //There's a little bit of lag between pressing F3 and the mouse actually
                    //centring in the window - this timer stops the camera freaking out!
                    ++__mouseLockTimer;
                    if (__mouseLockTimer > 4)
                    {
                        var _dX = window_mouse_get_x() - _centreX;
                        var _dY = window_mouse_get_y() - _centreY;
                        Rotate(-__mouseSensitivityX*_dX, -__mouseSensitivityY*_dY);
                    }
                    
                    //Now move the mouse
                    window_mouse_set(_centreX, _centreY);
                }
            }
        },
        [], -1);
        
        time_source_start(__timeSource);
    }
    
    static SetMouseLock = function(_state)
    {
        if (__mouseLock != _state)
        {
            __mouseLock = _state;
            __mouseLockTimer = 0;
        }
        
        return self;
    }
    
    static GetMouseLock = function()
    {
        return __mouseLock;
    }
    
    static SetMouseSensitivity = function(_x, _y)
    {
        __mouseSensitivityX = sign(_x) * max(0.001, abs(_x));
        __mouseSensitivityY = sign(_y) * max(0.001, abs(_y));
        
        return self;
    }
    
    static GetMouseSensitivity = function()
    {
        static _result = {
            x: 0,
            y: 0,
        };
        
        _result.x = __mouseSensitivityX;
        _result.y = __mouseSensitivityY;
        
        return _result;
    }
    
    static SetPerspective = function(_fov, _aspect, _zNear, _zFar)
    {
        fieldOfView = _fov;
        aspectRatio = _aspect;
        zNear       = _zNear;
        zFar        = _zFar;
        
        return self;
    }
    
    static SetPosition = function(_x, _y, _z)
    {
        x = _x;
        y = _y;
        z = _z;
        
        return self;
    }
    
    static SetRotation = function(_yaw, _pitch)
    {
        yaw   = _yaw;
        pitch = _pitch;
        
        return self;
    }
    
    static Rotate = function(_yaw, _pitch)
    {
        yaw   += _yaw;
        pitch += _pitch;
        pitch  = clamp(pitch, -89, 89); //Make sure we can't gimbal lock the camera
        
        return self;
    }
    
    static Move = function(_forward, _left, _up)
    {
        var _sin  = dsin(yaw);
        var _cos  = dcos(yaw);
        
        x +=  _forward*_cos - _left*_sin;
        y += -_forward*_sin - _left*_cos;
        z += _up;
        
        return self;
    }
    
    static DrawStateStart = function()
    {
        //Turn on z-writing and z-testing so we're ready for 3D rendering
        gpu_set_ztestenable(true);
        gpu_set_zwriteenable(true);
        
        //Counterclockwise faces are backfaces. We want to cull these so we're drawing less
        gpu_set_cullmode(cull_counterclockwise);
        
        //Set our view + projection matrices
        __oldWorldMatrix = matrix_get(matrix_world); 
        __oldViewMatrix  = matrix_get(matrix_view); 
        __oldProjMatrix  = matrix_get(matrix_projection);
        
        var _dX =  dcos(yaw)*dcos(pitch);
        var _dY = -dsin(yaw)*dcos(pitch);
        var _dZ =  dsin(pitch);

        var _viewMatrix = matrix_build_lookat(x, y, z,
                                              x + _dX, y + _dY, z + _dZ,
                                              0, 0, 1);
        var _projMatrix = matrix_build_projection_perspective_fov(fieldOfView, aspectRatio, zNear, zFar);
        
        matrix_set(matrix_view, _viewMatrix);
        matrix_set(matrix_projection, _projMatrix);
        
        return self;
    }
    
    static DrawStateEnd = function()
    {
        //Reset draw state
        matrix_set(matrix_world,      __oldWorldMatrix);
        matrix_set(matrix_view,       __oldViewMatrix);
        matrix_set(matrix_projection, __oldProjMatrix);
        
        gpu_set_ztestenable(false);
        gpu_set_zwriteenable(false);
        gpu_set_cullmode(cull_noculling);
        
        return self;
    }
}