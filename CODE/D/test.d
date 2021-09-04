// -- IMPORTS

import bif.color;
import bif.stream;
import bif.stream_field;
import bif.stream_state;
import std.stdio : write, writeln;
import std.conv : to;

// -- TYPES

struct STRUCT_DATA
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

    void Initialize(
        long seed
        )
    {
        Boolean = cast( bool )( seed & 1 );
        Natural8 = cast( ubyte )seed;
        Natural16 = cast( ushort )seed;
        Natural32 = cast( uint )seed;
        Natural64 = cast( ulong )seed;
        Integer8 = cast( byte )seed;
        Integer16 = cast( short )seed;
        Integer32 = cast( int )seed;
        Integer64 = cast( long )seed;
        Real32 = cast( float )seed;
        Real64 = cast( double )seed;
        Text = seed.to!string();
        TextArray = [ seed.to!string(), ( seed + 1 ).to!string() ];
        TextMap[ seed ] = seed.to!string();
        TextMap[ seed + 1 ] = ( seed + 1 ).to!string();
        Color.Red = cast( ubyte )seed;
        Color.Green = cast( ubyte )( seed + 1 );
        Color.Blue = cast( ubyte )( seed + 2 );
        Color.Alpha = cast( ubyte )( seed + 3 );
        ColorArray = [ Color, Color ];
        ColorMap[ seed ] = Color;
        ColorMap[ seed + 1 ] = Color;
    }

    // ~~

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

// ~~

class CLASS_DATA
{
    // -- ATTRIBUTES

    STRUCT_DATA
        FirstStructData,
        SecondStructData;

    // -- INQUIRIES

    void Dump(
        )
    {
        writeln( "FirstStructData:STRUCT_DATA = ", FirstStructData );
        writeln( "SecondStructData:STRUCT_DATA = ", SecondStructData );
    }

    // -- OPERATIONS

    void Initialize(
        long seed
        )
    {
        FirstStructData.Initialize( seed );
        SecondStructData.Initialize( seed );
    }

    // ~~

    void WriteValue(
        STREAM stream
        )
    {
        stream.WriteField( "FirstStructData:STRUCT_DATA", FirstStructData );
        stream.WriteField( "SecondStructData:STRUCT_DATA", SecondStructData );
    }

    // ~~

    void ReadValue(
        STREAM stream
        )
    {
        stream.ReadField( "FirstStructData:STRUCT_DATA", FirstStructData );
        stream.ReadField( "SecondStructData:STRUCT_DATA", SecondStructData );
    }
}

// ~~

class BIF_TEST
{
    // -- ATTRIBUTES

    CLASS_DATA
        ClassData;

    // -- INQUIRIES

    void Dump(
        )
    {
        ClassData.Dump();
    }

    // -- OPERATIONS

    void Initialize(
        long seed
        )
    {
        ClassData = new CLASS_DATA();
        ClassData.Initialize( seed );
    }

    // ~~

    void WriteValue(
        STREAM stream
        )
    {
        stream.WriteField( "ClassData:CLASS_DATA", ClassData );
    }

    // ~~

    void ReadValue(
        STREAM stream
        )
    {
        stream.ReadField( "ClassData:CLASS_DATA", ClassData );
    }
}

// -- FUNCTIONS

void TestWrite(
    )
{
    BIF_TEST
        bif_test;
    STREAM
        stream;

    bif_test = new BIF_TEST();
    bif_test.Initialize( 50 );
    stream = new STREAM();

    bif_test.Dump();
    bif_test.WriteValue( stream );
    stream.SaveFile( "test.bif" );
}

// ~~

void TestRead(
    )
{
    BIF_TEST
        bif_test;
    STREAM
        stream;

    bif_test = new BIF_TEST();
    stream = new STREAM();

    stream.LoadFile( "test.bif" );
    bif_test.ReadValue( stream );
    bif_test.Dump();
}

// ~~

void main(
    string[] argument_array
    )
{
    TestWrite();
    TestRead();
}
