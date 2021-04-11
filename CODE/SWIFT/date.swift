// -- IMPORTS

import SwiftUI;

// -- TYPES

struct DATE : STREAMABLE
{
    // -- ATTRIBUTES

    var MillisecondCount : UInt64;

    // -- CONSTRUCTORS

    init(
        )
    {
        MillisecondCount = 0;
    }

    // -- OPERATIONS

    mutating func WriteValue(
        _ stream : STREAM
        )
    {
        stream.WriteField( "MillisecondCount:UInt64", &MillisecondCount );
    }

    // ~~

    mutating func ReadValue(
        _ stream : STREAM
        )
    {
        _ = stream.ReadField( "MillisecondCount:UInt64", &MillisecondCount );
    }
}
