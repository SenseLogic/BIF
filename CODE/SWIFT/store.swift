// -- IMPORTS

import Foundation;

// -- TYPES

class STORE<_VALUE_ : STREAMABLE & IDENTIFIABLE> : STREAMABLE
{
    // -- ATTRIBUTES
    
    var ValueDictionary : [ IDENTIFIER : _VALUE_ ];
    
    // -- CONSTRUCTORS
    
    required init(
        )
    {
    }
    
    // -- OPERATIONS

    func WriteValue(
        _ stream : STREAM
        )
    {
    }

    // ~~

    func ReadValue(
        _ stream : STREAM
        )
    {
    }
}
