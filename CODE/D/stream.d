module bif.stream;

// -- IMPORTS

import bif.stream_field;
import bif.stream_state;
import std.file : read, write;
import std.stdio : writeln;

// -- TYPES

class STREAM
{
    // -- TYPES

    union SCALAR
    {
        uint
            Natural32;
        ulong
            Natural64;
        float
            Real32;
        double
            Real64;
    }

    // -- ATTRIBUTES

    ubyte[]
        ByteArray;
    ulong
        ByteIndex;
    ulong[]
        ByteIndexArray;
    string[]
        NameArray;
    ulong[ string ]
        NameIndexMap;
    Object[]
        ObjectArray;
    ulong[ Object ]
        ObjectIndexMap;
    STREAM_STATE[]
        StateArray;

    // -- CONSTRUCTORS

    this(
        )
    {
        ByteArray = null;
        ByteIndex = 0;
        ByteIndexArray = null;
        NameArray = null;
        NameIndexMap = null;
        ObjectArray = [ null ];
        ObjectIndexMap[ null ] = 0;
        StateArray = null;
    }

    // -- INQUIRIES

    ubyte[] GetByteArray(
        )
    {
        return ByteArray;
    }

    // ~~

    bool IsRead(
        )
    {
        return ByteIndex == ByteArray.length;
    }

    // -- OPERATIONS

    void SetByteArray(
        ubyte[] byte_array
        )
    {
        ByteArray = byte_array;
        ByteIndex = 0;
        ByteIndexArray = [ 0 ];
        NameArray = null;
        NameIndexMap = null;
        StateArray = [ STREAM_STATE( ulong( byte_array.length ) ) ];
    }

    // ~~

    void WriteBoolean(
        bool boolean
        )
    {
        ByteArray ~= boolean ? 1: 0;
    }

    // ~~

    void WriteNatural8(
        ubyte natural
        )
    {
        ByteArray ~= natural;
    }

    // ~~

    void WriteNatural16(
        ushort natural
        )
    {
        WriteNatural64( ulong( natural ) );
    }

    // ~~

    void WriteNatural32(
        uint natural
        )
    {
        WriteNatural64( ulong( natural ) );
    }

    // ~~

    void WriteNatural64(
        ulong natural
        )
    {
        ulong
            remaining_natural;

        remaining_natural = natural;

        while ( remaining_natural > 127 )
        {
            ByteArray ~= ubyte( 128 | ( remaining_natural & 127 ) );

            remaining_natural >>= 7;
        }

        ByteArray ~= ubyte( remaining_natural & 127 );
    }

    // ~~

    void WriteInteger8(
        byte integer
        )
    {
        ByteArray ~= ubyte( integer );
    }

    // ~~

    void WriteInteger16(
        short integer
        )
    {
        WriteInteger64( long( integer ) );
    }

    // ~~

    void WriteInteger32(
        int integer
        )
    {
        WriteInteger64( long( integer ) );
    }

    // ~~

    void WriteInteger64(
        long integer
        )
    {
        ulong
            natural;

        natural = ( ulong( integer ) & 0x7FFFFFFFFFFFFFFF ) << 1;

        if ( integer < 0 )
        {
            natural = ~natural | 1;
        }

        WriteNatural64( natural );
    }

    // ~~

    void WriteReal32(
        float real_
        )
    {
        SCALAR
            scalar;

        scalar.Real32 = real_;

        ByteArray ~= ubyte( scalar.Natural32 & 255 );
        ByteArray ~= ubyte( ( scalar.Natural32 >> 8 ) & 255 );
        ByteArray ~= ubyte( ( scalar.Natural32 >> 16 ) & 255 );
        ByteArray ~= ubyte( ( scalar.Natural32 >> 24 ) & 255 );
    }

    // ~~

    void WriteReal64(
        double real_
        )
    {
        SCALAR
            scalar;

        scalar.Real64 = real_;

        ByteArray ~= ubyte( scalar.Natural64 & 255 );
        ByteArray ~= ubyte( ( scalar.Natural64 >> 8 ) & 255 );
        ByteArray ~= ubyte( ( scalar.Natural64 >> 16 ) & 255 );
        ByteArray ~= ubyte( ( scalar.Natural64 >> 24 ) & 255 );
        ByteArray ~= ubyte( ( scalar.Natural64 >> 32 ) & 255 );
        ByteArray ~= ubyte( ( scalar.Natural64 >> 40 ) & 255 );
        ByteArray ~= ubyte( ( scalar.Natural64 >> 48 ) & 255 );
        ByteArray ~= ubyte( ( scalar.Natural64 >> 56 ) & 255 );
    }

    // ~~

    void WriteText(
        string text
        )
    {
        WriteNatural64( ulong( text.length ) );
        ByteArray ~= cast( ubyte[] )text;
    }

    // ~~

    void WriteName(
        string name
        )
    {
        ulong
            *found_name_index;

        found_name_index = name in NameIndexMap;

        if ( found_name_index !is null )
        {
            WriteNatural64( ( *found_name_index << 1 ) | 1 );
        }
        else
        {
            NameIndexMap[ name ] = ulong( NameArray.length );
            NameArray ~= name;

            WriteNatural64( ulong( name.length << 1 ) );
            ByteArray ~= cast( ubyte[] )name;
        }
    }

    // ~~

    void WriteValue( _VALUE_ )(
        ref _VALUE_ value
        )
    {
        static if ( is( _VALUE_ : Object ) )
        {
            ulong
                *found_object_index;

            if ( value is null )
            {
                WriteNatural64( 1 );
            }
            else
            {
                found_object_index = value in ObjectIndexMap;

                if ( found_object_index !is null )
                {
                    WriteNatural64( ( *found_object_index << 1 ) | 1 );
                }
                else
                {
                    WriteNatural64( ulong( ObjectArray.length << 1 ) );
                    ObjectIndexMap[ value ] = ulong( ObjectArray.length );
                    ObjectArray ~= value;

                    value.WriteValue( this );
                }
            }
        }
        else
        {
            value.WriteValue( this );
        }
    }

    // ~~

    void WriteByteCount(
        uint byte_count,
        ulong byte_index
        )
    {
        ByteArray[ byte_index ] = ubyte( byte_count & 255 );
        ByteArray[ byte_index + 1 ] = ubyte( ( byte_count >> 8 ) & 255 );
        ByteArray[ byte_index + 2 ] = ubyte( ( byte_count >> 16 ) & 255 );
        ByteArray[ byte_index + 3 ] = ubyte( ( byte_count >> 24 ) & 255 );
    }

    // ~~

    void WriteFieldHeader(
        string field_name
        )
    {
        WriteName( field_name );
        ByteArray ~= 0;
        ByteArray ~= 0;
        ByteArray ~= 0;
        ByteArray ~= 0;
        ByteIndexArray ~= ulong( ByteArray.length );
    }

    // ~~

    void WriteFieldFooter(
        )
    {
        uint
            byte_count;
        ulong
            byte_index;

        byte_index = ulong( ByteIndexArray[ ByteIndexArray.length - 1 ] );
        byte_count = cast( uint )( ulong( ByteArray.length ) - byte_index );
        WriteByteCount( byte_count, byte_index - 4 );
    }

    // ~~

    void WriteField( _VALUE_ )(
        string name,
        ref _VALUE_ value
        )
    {
        WriteFieldHeader( name );
        WriteValue( value );
        WriteFieldFooter();
    }

    // ~~

    void WriteArrayField( _VALUE_ )(
        string name,
        ref _VALUE_[] value_array
        )
    {
        WriteFieldHeader( name );
        WriteNatural64( ulong( value_array.length ) );

        foreach ( value_index; 0 .. value_array.length )
        {
            WriteValue( value_array[ value_index ]  );
        }

        WriteFieldFooter();
    }

    // ~~

    void WriteMapField( _KEY_, _VALUE_ )(
        string name,
        ref _VALUE_[ _KEY_ ] value_map
        )
    {
        WriteFieldHeader( name );
        WriteNatural64( ulong( value_map.length ) );

        foreach ( key, value; value_map )
        {
            WriteValue( key );
            WriteValue( value );
        }

        WriteFieldFooter();
    }

    // ~~

    void SaveFile(
        string file_path
        )
    {
        WriteByteArray( file_path, ByteArray );
    }

    // ~~

    bool ReadBoolean(
        )
    {
        return ReadNatural8() != 0;
    }

    // ~~

    ubyte ReadNatural8(
        )
    {
        ubyte
            byte_;

        byte_ = ByteArray[ ByteIndex ];
        ByteIndex += 1;

        return byte_;
    }

    // ~~

    ushort ReadNatural16(
        )
    {
        return cast( ushort )( ReadNatural64() );
    }

    // ~~

    uint ReadNatural32(
        )
    {
        return cast( uint )( ReadNatural64() );
    }

    // ~~

    ulong ReadNatural64(
        )
    {
        uint
            bit_count;
        ulong
            byte_,
            natural;

        natural = 0;
        bit_count = 0;

        do
        {
            byte_ = ulong( ReadNatural8() );
            natural |= ( byte_ & 127 ) << bit_count;
            bit_count += 7;
        }
        while ( ( byte_ & 128 ) != 0 );

        return natural;
    }

    // ~~

    byte ReadInteger8(
        )
    {
        return cast( byte )( ReadNatural8() );
    }

    // ~~

    short ReadInteger16(
        )
    {
        return cast( short )( ReadInteger64() );
    }

    // ~~

    int ReadInteger32(
        )
    {
        return cast( int )( ReadInteger64() );
    }

    // ~~

    long ReadInteger64(
        )
    {
        ulong
            natural;

        natural = ReadNatural64();

        if ( ( natural & 1 ) == 0 )
        {
            return long( natural >> 1 );
        }
        else
        {
            return long( ~( natural >> 1 ) | 0x8000000000000000 );
        }
    }

    // ~~

    float ReadReal32(
        )
    {
        SCALAR
            scalar;

        scalar.Natural32
            = uint( ReadNatural8() )
              | ( uint( ReadNatural8() ) << 8 )
              | ( uint( ReadNatural8() ) << 16 )
              | ( uint( ReadNatural8() ) << 24 );

        return scalar.Real32;
    }

    // ~~

    double ReadReal64(
        )
    {
        SCALAR
            scalar;

        scalar.Natural64
            = ulong( ReadNatural8() )
              | ( ulong( ReadNatural8() ) << 8 )
              | ( ulong( ReadNatural8() ) << 16 )
              | ( ulong( ReadNatural8() ) << 24 )
              | ( ulong( ReadNatural8() ) << 32 )
              | ( ulong( ReadNatural8() ) << 40 )
              | ( ulong( ReadNatural8() ) << 48 )
              | ( ulong( ReadNatural8() ) << 56 );

        return scalar.Real64;
    }

    // ~~

    string ReadText(
        )
    {
        ubyte[]
            byte_array;
        ulong
            character_count;

        character_count = ReadNatural64();
        byte_array = ByteArray[ ByteIndex .. ByteIndex + character_count ];
        ByteIndex += character_count;

        return cast( string )byte_array;
    }

    // ~~

    string ReadName(
        )
    {
        ubyte[]
            byte_array;
        ulong
            character_count,
            natural;
        string
            name;

        natural = ReadNatural64();

        if ( ( natural & 1 ) == 0 )
        {
            character_count = natural >> 1;
            byte_array = ByteArray[ ByteIndex .. ByteIndex + character_count ];
            ByteIndex += character_count;

            name = cast( string )byte_array;

            NameIndexMap[ name ] = ulong( NameArray.length );
            NameArray ~= name;

            return name;
        }
        else
        {
            return NameArray[ natural >> 1 ];
        }
    }

    // ~~

    void ReadValue( _VALUE_ )(
        ref _VALUE_ value
        )
    {
        static if ( is( _VALUE_ : Object ) )
        {
            ulong
                natural;

            natural = ReadNatural64();

            if ( natural == 1 )
            {
                value = null;
            }
            else if ( ( natural & 1 ) == 0 )
            {
                assert( natural >> 1 == ObjectArray.length );

                value = new _VALUE_();
                ObjectIndexMap[ value ] = ulong( ObjectArray.length );
                ObjectArray ~= value;

                value.ReadValue( this );
            }
            else
            {
                value = cast( _VALUE_ )ObjectArray[ natural >> 1 ];
            }
        }
        else
        {
            value.ReadValue( this );
        }
    }

    // ~~

    ulong ReadByteCount(
        )
    {
        return
            ulong( ReadNatural8() )
            | ( ulong( ReadNatural8() ) << 8 )
            | ( ulong( ReadNatural8() ) << 16 )
            | ( ulong( ReadNatural8() ) << 24 );
    }

    // ~~

    bool ReadFieldHeader(
        string field_name
        )
    {
        ulong
            byte_count;
        string
            name;
        STREAM_FIELD
            *skipped_stream_field;

        if ( StateArray[ StateArray.length - 1 ].SkippedFieldDictionary.length > 0 )
        {
            skipped_stream_field = field_name in StateArray[ StateArray.length - 1 ].SkippedFieldDictionary;

            if ( skipped_stream_field !is null )
            {
                ByteIndex = skipped_stream_field.ByteIndex;
                byte_count = skipped_stream_field.ByteCount;

                StateArray ~= STREAM_STATE( ByteIndex + byte_count );

                return true;
            }
        }

        while ( ByteIndex < StateArray[ StateArray.length - 1 ].PostByteIndex )
        {
            name = ReadName();
            byte_count = ReadByteCount();

            if ( name == field_name )
            {
                StateArray ~= STREAM_STATE( ByteIndex + byte_count );

                return true;
            }
            else
            {
                StateArray[ StateArray.length - 1 ].SkippedFieldDictionary[ name ] = STREAM_FIELD( ByteIndex, byte_count );
                ByteIndex += byte_count;
            }
        }

        writeln( "Missing field : ", field_name );

        return false;
    }

    // ~~

    void ReadFieldFooter(
        )
    {
        ByteIndex = StateArray[ StateArray.length - 1 ].PostByteIndex;
        StateArray = StateArray[ 0 .. StateArray.length - 1 ];
    }

    // ~~

    bool ReadField( _VALUE_ )(
        string name,
        ref _VALUE_ value
        )
    {
        if ( ReadFieldHeader( name ) )
        {
            ReadValue( value );
            ReadFieldFooter();

            return true;
        }
        else
        {
            return false;
        }
    }

    // ~~

    bool ReadArrayField( _VALUE_ )(
        string name,
        ref _VALUE_[] value_array
        )
    {
        _VALUE_
            value;
        long
            value_count;

        if ( ReadFieldHeader( name ) )
        {
            value_count = ReadNatural64();
            value_array = null;
            value_array.reserve( value_count );

            foreach ( value_index; 0 .. value_count )
            {
                ReadValue( value );
                value_array ~= value;
            }

            ReadFieldFooter();

            return true;
        }
        else
        {
            return false;
        }
    }

    // ~~

    bool ReadMapField( _KEY_, _VALUE_ )(
        string name,
        ref _VALUE_[ _KEY_ ] value_map
        )
    {
        _KEY_
            key;
        _VALUE_
            value;
        long
            value_count;

        if ( ReadFieldHeader( name ) )
        {
            value_count = ReadNatural64();
            value_map = null;

            foreach ( value_index; 0 .. value_count )
            {
                ReadValue( key );
                ReadValue( value );
                value_map[ key ] = value;
            }

            ReadFieldFooter();

            return true;
        }
        else
        {
            return false;
        }
    }

    // ~~

    void LoadFile(
        string file_path
        )
    {
        SetByteArray( ReadByteArray( file_path ) );
    }
}

// -- FUNCTIONS

void WriteByteArray(
    string file_path,
    ubyte[] byte_array
    )
{
    file_path.write( byte_array );
}

// ~~

ubyte[] ReadByteArray(
    string file_path
    )
{
    return cast( ubyte[] )file_path.read();
}

// ~~

void WriteValue(
    bool value,
    STREAM stream
    )
{
    stream.WriteBoolean( value );
}

// ~~

void ReadValue(
    ref bool value,
    STREAM stream
    )
{
    value = stream.ReadBoolean();
}

// ~~

void WriteValue(
    ubyte value,
    STREAM stream
    )
{
    stream.WriteNatural8( value );
}

// ~~

void ReadValue(
    ref ubyte value,
    STREAM stream
    )
{
    value = stream.ReadNatural8();
}

// ~~

void WriteValue(
    ushort value,
    STREAM stream
    )
{
    stream.WriteNatural16( value );
}

// ~~

void ReadValue(
    ref ushort value,
    STREAM stream
    )
{
    value = stream.ReadNatural16();
}

// ~~

void WriteValue(
    uint value,
    STREAM stream
    )
{
    stream.WriteNatural32( value );
}

// ~~

void ReadValue(
    ref uint value,
    STREAM stream
    )
{
    value = stream.ReadNatural32();
}

// ~~

void WriteValue(
    ulong value,
    STREAM stream
    )
{
    stream.WriteNatural64( value );
}

// ~~

void ReadValue(
    ref ulong value,
    STREAM stream
    )
{
    value = stream.ReadNatural64();
}

// ~~

void WriteValue(
    byte value,
    STREAM stream
    )
{
    stream.WriteInteger8( value );
}

// ~~

void ReadValue(
    ref byte value,
    STREAM stream
    )
{
    value = stream.ReadInteger8();
}

// ~~

void WriteValue(
    short value,
    STREAM stream
    )
{
    stream.WriteInteger16( value );
}

// ~~

void ReadValue(
    ref short value,
    STREAM stream
    )
{
    value = stream.ReadInteger16();
}


// ~~

void WriteValue(
    int value,
    STREAM stream
    )
{
    stream.WriteInteger32( value );
}

// ~~

void ReadValue(
    ref int value,
    STREAM stream
    )
{
    value = stream.ReadInteger32();
}

// ~~

void WriteValue(
    long value,
    STREAM stream
    )
{
    stream.WriteInteger64( value );
}

// ~~

void ReadValue(
    ref long value,
    STREAM stream
    )
{
    value = stream.ReadInteger64();
}

// ~~

void WriteValue(
    float value,
    STREAM stream
    )
{
    stream.WriteReal32( value );
}

// ~~

void ReadValue(
    ref float value,
    STREAM stream
    )
{
    value = stream.ReadReal32();
}

// ~~


void WriteValue(
    double value,
    STREAM stream
    )
{
    stream.WriteReal64( value );
}

// ~~

void ReadValue(
    ref double value,
    STREAM stream
    )
{
    value = stream.ReadReal64();
}

// ~~

void WriteValue(
    string value,
    STREAM stream
    )
{
    stream.WriteText( value );
}

// ~~

void ReadValue(
    ref string value,
    STREAM stream
    )
{
    value = stream.ReadText();
}
