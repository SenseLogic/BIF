// -- IMPORTS

import Foundation;

// -- TYPES

struct STREAM_STATE
{
    // -- ATTRIBUTES
    
    var PostByteIndex : UInt64;
    var SkippedFieldDictionary : [ String : STREAM_FIELD ];
    
    // -- CONSTRUCTORS
    
    init(
        )
    {
        PostByteIndex = 0;
        SkippedFieldDictionary = [:];
    }
    
    // ~~
    
    init(
        _ post_byte_index : UInt64
        )
    {
        PostByteIndex = post_byte_index;
        SkippedFieldDictionary = [:];
    }
}
