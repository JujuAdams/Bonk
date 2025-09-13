#macro  DOTOBJ_OUTPUT_DEBUG        false  //Outputs extra debug info (this is useful to check the library is working properly!)
#macro  DOTOBJ_OUTPUT_WARNINGS     false  //Outputs warning messages to the console
#macro  DOTOBJ_OUTPUT_LOAD_TIME    true   //Outputs the amount of time taken to load a .obj file to the console
#macro  DOTOBJ_OUTPUT_COMMENTS     false  //Outputs comments found in .obj files to the console
#macro  DOTOBJ_IGNORE_LINES        true   //Some .obj files use line primitives for visualisation in editors. We don't support line primitives so we usually want to ignore this data when loading
#macro  DOTOBJ_OBJECTS_ARE_GROUPS  true   //Process all objects as if they were groups

//Transformation rules that are enabled by DotobjSetTransformOnLoad()
#macro  DOTOBJ_POSITION_TRANSFORM  _vx = _old_vx;\n
                                   _vy = _old_vz;\n
                                   _vz = _old_vy;

#macro  DOTOBJ_NORMAL_TRANSFORM  _nx = _old_nx;\n
                                 _ny = _old_nz;\n
                                 _nz = _old_ny;