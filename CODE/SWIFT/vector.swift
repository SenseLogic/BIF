// -- IMPORTS

import Foundation;

// -- TYPES

struct VECTOR : STREAMABLE
{
    // -- ATTRIBUTES

    var X : Float64;
    var Y : Float64;

    // -- CONSTRUCTORS

    init(
        )
    {
        X = 0.0;
        Y = 0.0;
    }

    // ~~

    init(
        _ x : Float64,
        _ y : Float64
        )
    {
        X = x;
        Y = y;
    }

    // ~~

    init(
        _ graphic_point : CGPoint
        )
    {
        X = Float64( graphic_point.x );
        Y = Float64( graphic_point.y );
    }

    // -- OPERATORS

    static func ==(
        first_vector : VECTOR,
        second_vector : VECTOR
        ) -> Bool
    {
        return
            first_vector.X == second_vector.X
            && first_vector.Y == second_vector.Y;
    }

    // ~~

    static func !=(
        first_vector : VECTOR,
        second_vector : VECTOR
        ) -> Bool
    {
        return
            first_vector.X != second_vector.X
            || first_vector.Y != second_vector.Y;
    }

    // ~~

    static func +(
        first_vector : VECTOR,
        second_vector : VECTOR
        ) -> VECTOR
    {
        return VECTOR( first_vector.X + second_vector.X, first_vector.Y + second_vector.Y );
    }

    // ~~

    static func -(
        first_vector : VECTOR,
        second_vector : VECTOR
        ) -> VECTOR
    {
        return VECTOR( first_vector.X - second_vector.X, first_vector.Y - second_vector.Y );
    }

    // ~~

    static func *(
        vector : VECTOR,
        factor : Float64
        ) -> VECTOR
    {
        return VECTOR( vector.X * factor, vector.Y * factor );
    }

    // ~~

    static func /(
        vector : VECTOR,
        divisor : Float64
        ) -> VECTOR
    {
        var one_over_divisor : Float64;

        if ( divisor.IsRoughlyZero() )
        {
            return VECTOR();
        }
        else
        {
            one_over_divisor = 1.0 / divisor;

            return VECTOR( vector.X * one_over_divisor, vector.Y * one_over_divisor );
        }
    }

    // -- INQUIRIES

    func GetPoint(
        ) -> CGPoint
    {
        return CGPoint( x : CGFloat( X ), y : CGFloat( Y ) );
    }

    // ~~

    func GetDotProduct(
        _ vector : VECTOR
        ) -> Float64
    {
        return X * vector.X + Y * vector.Y;
    }

    // ~~

    func GetSquareLength(
        ) -> Float64
    {
        return X * X + Y * Y;
    }

    // ~~

    func GetLength(
        ) -> Float64
    {
        return ( X * X + Y * Y ).squareRoot();
    }

    // ~~

    func GetNormalizedVector(
        ) -> VECTOR
    {
        return self / GetLength();
    }

    // -- OPERATIONS

    mutating func WriteValue(
        _ stream : STREAM
        )
    {
        stream.WriteField( "X:Float64", &X );
        stream.WriteField( "Y:Float64", &Y );
    }

    // ~~

    mutating func ReadValue(
        _ stream : STREAM
        )
    {
        _ = stream.ReadField( "X:Float64", &X );
        _ = stream.ReadField( "Y:Float64", &Y );
    }

    // ~~

    mutating func Add(
        _ vector : VECTOR
        )
    {
        X += vector.X;
        Y += vector.Y;
    }

    // ~~

    mutating func Substract(
        _ vector : VECTOR
        )
    {
        X -= vector.X;
        Y -= vector.Y;
    }

    // ~~

    mutating func Multiply(
        _ factor : Float64
        )
    {
        X *= factor;
        Y *= factor;
    }

    // ~~

    mutating func Divide(
        _ divisor : Float64
        )
    {
        var one_over_divisor : Float64;

        if ( divisor.IsRoughlyZero() )
        {
            X = 0.0;
            Y = 0.0;
        }
        else
        {
            one_over_divisor = 1.0 / divisor;
            X *= one_over_divisor;
            Y *= one_over_divisor;
        }
    }

    // ~~

    mutating func Normalize(
        )
    {
        Divide( GetLength() );
    }
}
