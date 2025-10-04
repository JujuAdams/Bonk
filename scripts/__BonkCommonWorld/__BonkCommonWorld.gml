// Feather disable all

function __BonkCommonWorld()
{
    __minCellX = 0;
    __maxCellX = 0;
    __maxCellY = 0;
    __minCellY = 0;
    __minCellZ = 0;
    __maxCellZ = 0;
    
    __spatialDict = {};
    
    if (BONK_RUNNING_FROM_IDE)
    {
        __debugDict = {};
    }
}