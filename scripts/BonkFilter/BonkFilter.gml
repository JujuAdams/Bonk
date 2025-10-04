// Feather disable all

/// Constructs a group filter that is compatible with various Bonk functions, such as
/// `BonkInstanceMoveAndDeflect()`. This function returns a 64-bit integer, a "bitvector", that
/// encodes the group logic you'd like to execute.
/// 
/// There are three parts to Bonk's group logic:
/// 
/// 1. Accept shapes that are in any of the OR groups
/// 2. Accept shapes that are in every one of the AND groups
/// 3. Reject shapes that are in any of the NOT groups
/// 
/// If you pass a value of `undefined` for the `orGroups` parameter then the filter `0xFFFFF` is
/// used. This will match every Bonk shape that is in any group.
/// 
/// You are able to filter for 20 different groups. The maximum value for a single group is
/// `0x80000` (`0b1000_0000_0000_0000_0000` or `524,288` in decimal). You should store group values
/// as powers-of-two, typically set up by using the `<<` operator e.g. group 13 would be `1 << 13`.
/// As such, it's helpful to think of groups as being zero indexed and as such the maximum group
/// index is `19`. Observant developers will notice that it would be possible to support `21`
/// groups but extra space is reserved in the filter integer for future option bits.
/// 
/// Groups can be set on Bonk structs and Bonk instances by setting the `bonkGroup` variable. The
/// default group for a Bonk struct/instance can be set using the config macro `BONK_DEFAULT_GROUP`.
/// The typical value for this macro is `1` which ensures that every Bonk struct/instance is in at
/// least one group.
/// 
/// Examples of use:
/// 
/// `filter = BonkFilter(1 << 3)`
///   Creates a filter that only allows shapes in group 3.
/// 
/// `filter = BonkFilter((1 << 1) | (1 <<3))`
///   Creates a filter that only allows shapes in group 1 or group 3.
/// 
/// `filter = BonkFilter(0, (1 << 2) | (1 << 4))`
///   Creates a filter that only allows shapes that are in both group 2 and group 4.
/// 
/// `filter = BonkFilter(0, (1 << 2) | (1 << 4), (1 << 13))`
///   Creates a filter that only allows shapes that are in both group 2 and group 4 but never in
///   group 13.
/// 
/// `filter = BonkFilter((1 << 19), (1 << 0) | (1 << 1), (1 << 8))`
///   Creates a filter that allows shapes that are in group 19, or both group 0 and group 1.
///   However, any shape in group 8 is always excluded.
/// 
/// @param [orGroups=any]
/// @param [andGroups=none]
/// @param [notGroups=none]

function BonkFilter(_orGroups = 0xFFFFF, _andGroups = 0x00, _notGroups = 0x00)
{
    return ((_notGroups & 0xFFFFF) << 40) | ((_andGroups & 0xFFFFF) << 20) | (_orGroups & 0xFFFFF);
}