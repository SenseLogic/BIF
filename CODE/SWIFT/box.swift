// -- IMPORTS

import SwiftUI;

// -- TYPES

struct BOX : STREAMABLE
{
    // -- ATTRIBUTES

    var MinimumPositionVector : VECTOR;
    var MaximumPositionVector : VECTOR;

    // -- CONSTRUCTORS

    init(
        )
    {
        MinimumPositionVector = VECTOR();
        MaximumPositionVector = VECTOR();
    }

    // -- OPERATIONS

    mutating func WriteValue(
        _ stream : STREAM
        )
    {
        stream.WriteField( "MinimumPositionVector:VECTOR", &MinimumPositionVector );
        stream.WriteField( "MaximumPositionVector:VECTOR", &MaximumPositionVector );
    }

    // ~~

    mutating func ReadValue(
        _ stream : STREAM
        )
    {
        _ = stream.ReadField( "MinimumPositionVector:VECTOR", &MinimumPositionVector );
        _ = stream.ReadField( "MaximumPositionVector:VECTOR", &MaximumPositionVector );
    }
}
