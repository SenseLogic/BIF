// -- IMPORTS

import bif.color;
import bif.stream;
import bif.stream_field;
import bif.stream_state;
import std.stdio : write, writeln;
import std.conv : to;

// -- TYPES

class OBJECT
{
    // -- ATTRIBUTES

    bool
        Boolean;
    ubyte
        Natural8;
    ushort
        Natural16;
    uint
        Natural32;
    ulong
        Natural64;
    byte
        Integer8;
    short
        Integer16;
    int
        Integer32;
    long
        Integer64;
    float
        Real32 = 0.0;
    double
        Real64 = 0.0;
    string
        Text;
    string[]
        TextArray;
    string[ long ]
        TextMap;
    COLOR
        Color;
    COLOR[]
        ColorArray;
    COLOR[ long ]
        ColorMap;

    // -- CONSTRUCTORS

    this(
        )
    {
    }

    // ~~

    this(
        long value
        )
    {
        Boolean = cast( bool )( value & 1 );
        Natural8 = cast( ubyte )value;
        Natural16 = cast( ushort )value;
        Natural32 = cast( uint )value;
        Natural64 = cast( ulong )value;
        Integer8 = cast( byte )value;
        Integer16 = cast( short )value;
        Integer32 = cast( int )value;
        Integer64 = cast( long )value;
        Real32 = cast( float )value;
        Real64 = cast( double )value;
        Text = value.to!string();
        TextArray = [ value.to!string(), ( value + 1 ).to!string() ];
        TextMap[ value ] = value.to!string();
        TextMap[ value + 1 ] = ( value + 1 ).to!string();
        Color.Red = cas( ubyte )value;
        Color.Green = cast( ubyte )( value + 1 );
        Color.Blue = cast( ubyte )( value + 2 );
        Color.Alpha = cast( ubyte )( value + 3 );
        ColorArray = [ Color, Color ];
        ColorMap[ value ] = Color;
        ColorMap[ value + 1 ] = Color;

    }

    // -- INQUIRIES

    void Dump(
        )
    {
        writeln( "Boolean:bool = ", Boolean );
        writeln( "Natural8:ubyte = ", Natural8 );
        writeln( "Natural16:ushort = ", Natural16 );
        writeln( "Natural32:uint = ", Natural32 );
        writeln( "Natural64:ulong = ", Natural64 );
        writeln( "Integer8:byte = ", Integer8 );
        writeln( "Integer16:short = ", Integer16 );
        writeln( "Integer32:int = ", Integer32 );
        writeln( "Integer64:long = ", Integer64 );
        writeln( "Real32:float = ", Real32 );
        writeln( "Real64:double = ", Real64 );
        writeln( "Text:string = ", Text );
        writeln( "TextArray:string[] = ", TextArray );
        writeln( "TextMap:string[long] = ", TextMap );
        writeln( "Color:COLOR = ", Color );
        writeln( "ColorArray:COLOR[] = ", ColorArray );
        writeln( "ColorMap:COLOR[long] = ", ColorMap );
    }

    // -- OPERATIONS

    void WriteValue(
        STREAM stream
        )
    {
        stream.WriteField( "Boolean:bool", Boolean );
        stream.WriteField( "Natural8:ubyte", Natural8 );
        stream.WriteField( "Natural16:ushort", Natural16 );
        stream.WriteField( "Natural32:uint", Natural32 );
        stream.WriteField( "Natural64:ulong", Natural64 );
        stream.WriteField( "Integer8:byte", Integer8 );
        stream.WriteField( "Integer16:short", Integer16 );
        stream.WriteField( "Integer32:int", Integer32 );
        stream.WriteField( "Integer64:long", Integer64 );
        stream.WriteField( "Real32:float", Real32 );
        stream.WriteField( "Real64:double", Real64 );
        stream.WriteField( "Text:string", Text );
        stream.WriteArrayField( "TextArray:string[]", TextArray );
        stream.WriteMapField( "TextMap:string[long]", TextMap );
        stream.WriteField( "Color:COLOR", Color );
        stream.WriteArrayField( "ColorArray:COLOR[]", ColorArray );
        stream.WriteMapField( "ColorMap:COLOR[long]", ColorMap );
    }

    // ~~

    void ReadValue(
        STREAM stream
        )
    {
        stream.ReadField( "Boolean:bool", Boolean );
        stream.ReadField( "Natural8:ubyte", Natural8 );
        stream.ReadField( "Natural16:ushort", Natural16 );
        stream.ReadField( "Natural32:uint", Natural32 );
        stream.ReadField( "Natural64:ulong", Natural64 );
        stream.ReadField( "Integer8:byte", Integer8 );
        stream.ReadField( "Integer16:short", Integer16 );
        stream.ReadField( "Integer32:int", Integer32 );
        stream.ReadField( "Integer64:long", Integer64 );
        stream.ReadField( "Real32:float", Real32 );
        stream.ReadField( "Real64:double", Real64 );
        stream.ReadField( "Text:string", Text );
        stream.ReadArrayField( "TextArray:string[]", TextArray );
        stream.ReadMapField( "TextMap:string[long]", TextMap );
        stream.ReadField( "Color:COLOR", Color );
        stream.ReadArrayField( "ColorArray:COLOR[]", ColorArray );
        stream.ReadMapField( "ColorMap:COLOR[long]", ColorMap );
    }
}

// -- FUNCTIONS

void TestWrite(
    )
{
    OBJECT
        object;
    STREAM
        stream;

    object = new OBJECT( 50 );
    stream = new STREAM();

    object.Dump();
    object.WriteValue( stream );
    stream.SaveFile( "test.bif" );
}

// ~~

void TestRead(
    )
{
    OBJECT
        object;
    STREAM
        stream;

    object = new OBJECT();
    stream = new STREAM();

    stream.LoadFile( "test.bif" );
    object.ReadValue( stream );
    object.Dump();
}

// ~~

void main(
    string[] argument_array
    )
{
    TestWrite();
    TestRead();
}
