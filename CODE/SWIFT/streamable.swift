// -- IMPORTS

import Foundation;

// -- TYPES

protocol STREAMABLE
{
    // -- CONSTRUCTORS

    init(
        );

    // -- OPERATIONS

    mutating func WriteValue(
        _ stream : STREAM
        );

    // ~~

    mutating func ReadValue(
        _ stream : STREAM
        );
}
