// -- IMPORTS

import SwiftUI;

// -- TYPES

struct COLOR : STREAMABLE
{
    // -- ATTRIBUTES

    var Red : Float64;
    var Green : Float64;
    var Blue : Float64;
    var Alpha : Float64;

    // -- CONSTRUCTORS

    init(
        )
    {
        Red = 0.0;
        Green = 0.0;
        Blue = 0.0;
        Alpha = 1.0;
    }

    // ~~

    init(
        _ red : Float64,
        _ green : Float64,
        _ blue : Float64,
        _ alpha : Float64 = 1.0
        )
    {
        Red = red;
        Green = green;
        Blue = blue;
        Alpha = alpha;
    }

    // -- INQUIRIES

    func GetColor(
        ) -> CGColor
    {
        return CGColor( srgbRed: CGFloat( Red ), green: CGFloat( Green ), blue: CGFloat( Blue ), alpha: CGFloat( Alpha ) );
    }

    // -- OPERATIONS

    mutating func WriteValue(
        _ stream : STREAM
        )
    {
        stream.WriteField( "Red:Float64", &Red );
        stream.WriteField( "Green:Float64", &Green );
        stream.WriteField( "Blue:Float64", &Blue );
        stream.WriteField( "Alpha:Float64", &Alpha );
    }

    // ~~

    mutating func ReadValue(
        _ stream : STREAM
        )
    {
        _ = stream.ReadField( "Red:Float64", &Red );
        _ = stream.ReadField( "Green:Float64", &Green );
        _ = stream.ReadField( "Blue:Float64", &Blue );
        _ = stream.ReadField( "Alpha:Float64", &Alpha );
    }
}
