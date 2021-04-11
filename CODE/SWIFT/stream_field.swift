// -- IMPORTS

import SwiftUI;

// -- TYPES

struct STREAM_FIELD
{
    // -- ATTRIBUTES
    
    var ByteIndex : UInt64;
    var ByteCount : UInt64;
    
    // -- CONSTRUCTORS
    
    init(
        )
    {
        ByteIndex = 0;
        ByteCount = 0;
    }
    
    // ~~
    
    init(
        _ byte_index : UInt64,
        _ byte_count : UInt64
        )
    {
        ByteIndex = byte_index;
        ByteCount = byte_count;
    }
}
