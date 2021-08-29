module bif.color;

// -- IMPORTS

import bif.stream;

// -- TYPES

struct COLOR
{
    // -- ATTRIBUTES

    double
        Red = 0.0,
        Green = 0.0,
        Blue = 0.0,
        Alpha = 1.0;

    // -- CONSTRUCTORS

    this(
        double red,
        double green,
        double blue,
        double alpha = 1.0
        )
    {
        Red = red;
        Green = green;
        Blue = blue;
        Alpha = alpha;
    }

    // -- OPERATIONS

    void WriteValue(
        STREAM stream
        )
    {
        stream.WriteField( "Red:double", Red );
        stream.WriteField( "Green:double", Green );
        stream.WriteField( "Blue:double", Blue );
        stream.WriteField( "Alpha:double", Alpha );
    }

    // ~~

    void ReadValue(
        STREAM stream
        )
    {
        stream.ReadField( "Red:double", Red );
        stream.ReadField( "Green:double", Green );
        stream.ReadField( "Blue:double", Blue );
        stream.ReadField( "Alpha:double", Alpha );
    }
}
