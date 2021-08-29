// -- IMPORTS

import Foundation;

// -- TYPES

class STREAM
{
    // -- ATTRIBUTES

    var ByteArray : [ UInt8 ];
    var ByteIndex : UInt64;
    var ByteIndexArray : [ UInt64 ];
    var NameArray : [ String ];
    var NameIndexDictionary : [ String : UInt64 ];
    var StateArray : [ STREAM_STATE ];

    // -- CONSTRUCTORS

    init(
        )
    {
        ByteArray = [];
        ByteIndex = 0;
        ByteIndexArray = [];
        NameArray = [];
        NameIndexDictionary = [:];
        StateArray = [];
    }

    // -- INQUIRIES

    func GetByteArray(
        ) -> [ UInt8 ]
    {
        return ByteArray;
    }

    // ~~

    func IsRead(
        ) -> Bool
    {
        return ByteIndex == ByteArray.count;
    }

    // -- OPERATIONS

    func SetByteArray(
        _ byte_array : [ UInt8 ]
        )
    {
        ByteArray = byte_array;
        ByteIndex = 0;
        ByteIndexArray = [ 0 ];
        NameArray = [];
        NameIndexDictionary = [:];
        StateArray = [ STREAM_STATE( UInt64( byte_array.count ) ) ];
    }

    // ~~

    func WriteBoolean(
        _ boolean : Bool
        )
    {
        ByteArray.append( boolean ? 1: 0 );
    }

    // ~~

    func WriteNatural8(
        _ natural : UInt8
        )
    {
        ByteArray.append( natural );
    }

    // ~~

    func WriteNatural16(
        _ natural : UInt16
        )
    {
        WriteNatural64( UInt64( natural ) );
    }

    // ~~

    func WriteNatural32(
        _ natural : UInt32
        )
    {
        WriteNatural64( UInt64( natural ) );
    }

    // ~~

    func WriteNatural64(
        _ natural : UInt64
        )
    {
        var remaining_natural : UInt64;

        remaining_natural = natural;

        while ( remaining_natural > 127 )
        {
            ByteArray.append( UInt8( 128 | ( remaining_natural & 127 ) ) );

            remaining_natural >>= 7;
        }

        ByteArray.append( UInt8( remaining_natural & 127 ) );
    }

    // ~~

    func WriteInteger8(
        _ integer : Int8
        )
    {
        ByteArray.append( UInt8( bitPattern : integer ) );
    }

    // ~~

    func WriteInteger16(
        _ integer : Int16
        )
    {
        WriteInteger64( Int64( integer ) );
    }

    // ~~

    func WriteInteger32(
        _ integer : Int32
        )
    {
        WriteInteger64( Int64( integer ) );
    }

    // ~~

    func WriteInteger64(
        _ integer : Int64
        )
    {
        var natural : UInt64;

        natural = ( UInt64( bitPattern : integer ) & 0x7FFFFFFFFFFFFFFF ) << 1;

        if ( integer < 0 )
        {
            natural = ~natural | 1;
        }

        WriteNatural64( natural );
    }

    // ~~

    func WriteReal32(
        _ real_ : Float32
        )
    {
        var natural : UInt32;

        natural = real_.bitPattern;

        ByteArray.append( UInt8( natural & 255 ) );
        ByteArray.append( UInt8( ( natural >> 8 ) & 255 ) );
        ByteArray.append( UInt8( ( natural >> 16 ) & 255 ) );
        ByteArray.append( UInt8( ( natural >> 24 ) & 255 ) );
    }

    // ~~

    func WriteReal64(
        _ real_ : Float64
        )
    {
        var natural : UInt64;

        natural = real_.bitPattern;

        ByteArray.append( UInt8( natural & 255 ) );
        ByteArray.append( UInt8( ( natural >> 8 ) & 255 ) );
        ByteArray.append( UInt8( ( natural >> 16 ) & 255 ) );
        ByteArray.append( UInt8( ( natural >> 24 ) & 255 ) );
        ByteArray.append( UInt8( ( natural >> 32 ) & 255 ) );
        ByteArray.append( UInt8( ( natural >> 40 ) & 255 ) );
        ByteArray.append( UInt8( ( natural >> 48 ) & 255 ) );
        ByteArray.append( UInt8( ( natural >> 56 ) & 255 ) );
    }

    // ~~

    func WriteText(
        _ text : String
        )
    {
        WriteNatural64( UInt64( text.count ) );
        ByteArray.append( contentsOf : Array( text.utf8 ) );
    }

    // ~~

    func WriteName(
        _ name : String
        )
    {
        if let found_name_index = NameIndexDictionary[ name ]
        {
            WriteNatural64( ( found_name_index << 1 ) | 1 );
        }
        else
        {
            NameIndexDictionary[ name ] = UInt64( NameArray.count );
            NameArray.append( name );

            WriteNatural64( UInt64( name.count << 1 ) );
            ByteArray.append( contentsOf : Array( name.utf8 ) );
        }
    }

    // ~~

    func WriteByteCount(
        _ byte_count : UInt32,
        _ byte_index : UInt64
        )
    {
        ByteArray[ Int( byte_index ) ] = UInt8( byte_count & 255 );
        ByteArray[ Int( byte_index + 1 ) ] = UInt8( ( byte_count >> 8 ) & 255 );
        ByteArray[ Int( byte_index + 2 ) ] = UInt8( ( byte_count >> 16 ) & 255 );
        ByteArray[ Int( byte_index + 3 ) ] = UInt8( ( byte_count >> 24 ) & 255 );
    }

    // ~~

    func WriteFieldHeader(
        _ field_name : String
        )
    {
        WriteName( field_name );
        ByteArray.append( 0 );
        ByteArray.append( 0 );
        ByteArray.append( 0 );
        ByteArray.append( 0 );
        ByteIndexArray.append( UInt64( ByteArray.count ) );
    }

    // ~~

    func WriteFieldFooter(
        )
    {
        var byte_count : UInt32;
        var byte_index : UInt64;

        byte_index = UInt64( ByteIndexArray[ ByteIndexArray.count - 1 ] );
        byte_count = UInt32( UInt64( ByteArray.count ) - byte_index );
        WriteByteCount( byte_count, byte_index - 4 );
    }

    // ~~

    func WriteField<_VALUE_ : STREAMABLE>(
        _ name : String,
        _ value : inout _VALUE_
        )
    {
        WriteFieldHeader( name );
        value.WriteValue( self );
        WriteFieldFooter();
    }

    // ~~

    func WriteField<_VALUE_ : STREAMABLE>(
        _ name : String,
        _ value_array : inout [ _VALUE_ ]
        )
    {
        WriteFieldHeader( name );
        WriteNatural64( UInt64( value_array.count ) );

        for value_index in 0 ..< value_array.count
        {
            value_array[ value_index ].WriteValue( self );
        }

        WriteFieldFooter();
    }

    // ~~

    func WriteField<_KEY_ : STREAMABLE, _VALUE_ : STREAMABLE>(
        _ name : String,
        _ value_dictionary : inout [ _KEY_ : _VALUE_ ]
        )
    {
        var written_key : _KEY_;
        var written_value : _VALUE_;

        WriteFieldHeader( name );
        WriteNatural64( UInt64( value_dictionary.count ) );

        for ( key, value ) in value_dictionary
        {
            written_key = key;
            written_key.WriteValue( self );

            written_value = value;
            written_value.WriteValue( self );
        }

        WriteFieldFooter();
    }

    // ~~

    func SaveFile(
        _ file_path : String
        )
    {
        WriteByteArray( file_path, ByteArray );
    }

    // ~~

    func ReadBoolean(
        ) -> Bool
    {
        return ReadNatural8() != 0;
    }

    // ~~

    func ReadNatural8(
        ) -> UInt8
    {
        var byte_ : UInt8;

        byte_ = ByteArray[ Int( ByteIndex ) ];
        ByteIndex += 1;

        return byte_;
    }

    // ~~

    func ReadNatural16(
        ) -> UInt16
    {
        return UInt16( ReadNatural64() );
    }

    // ~~

    func ReadNatural32(
        ) -> UInt32
    {
        return UInt32( ReadNatural64() );
    }

    // ~~

    func ReadNatural64(
        ) -> UInt64
    {
        var bit_count : UInt32;
        var byte_: UInt64;
        var natural : UInt64;

        natural = 0;
        bit_count = 0;

        repeat
        {
            byte_ = UInt64( ReadNatural8() );
            natural |= ( byte_ & 127 ) << bit_count;
            bit_count += 7;
        }
        while ( ( byte_ & 128 ) != 0 );

        return natural;
    }

    // ~~

    func ReadInteger8(
        ) -> Int8
    {
        return Int8( bitPattern : ReadNatural8() );
    }

    // ~~

    func ReadInteger16(
        ) -> Int16
    {
        return Int16( ReadInteger64() );
    }

    // ~~

    func ReadInteger32(
        ) -> Int32
    {
        return Int32( ReadInteger64() );
    }

    // ~~

    func ReadInteger64(
        ) -> Int64
    {
        var natural : UInt64;

        natural = ReadNatural64();

        if ( ( natural & 1 ) == 0 )
        {
            return Int64( natural >> 1 );
        }
        else
        {
            return Int64( bitPattern : ~( natural >> 1 ) | 0x8000000000000000 );
        }
    }

    // ~~

    func ReadReal32(
        ) -> Float32
    {
        var natural : UInt32;

        natural
            = UInt32( ReadNatural8() )
              | ( UInt32( ReadNatural8() ) << 8 )
              | ( UInt32( ReadNatural8() ) << 16 )
              | ( UInt32( ReadNatural8() ) << 24 );

        return Float32( bitPattern : natural );
    }

    // ~~

    func ReadReal64(
        ) -> Float64
    {
        var natural : UInt64;

        natural
            = UInt64( ReadNatural8() )
              | ( UInt64( ReadNatural8() ) << 8 )
              | ( UInt64( ReadNatural8() ) << 16 )
              | ( UInt64( ReadNatural8() ) << 24 )
              | ( UInt64( ReadNatural8() ) << 32 )
              | ( UInt64( ReadNatural8() ) << 40 )
              | ( UInt64( ReadNatural8() ) << 48 )
              | ( UInt64( ReadNatural8() ) << 56 );

        return Float64( bitPattern : natural );
    }

    // ~~

    func ReadText(
        ) -> String
    {
        var byte_array : [ UInt8 ];
        var character_count : UInt64;

        character_count = ReadNatural64();
        byte_array = Array( ByteArray[ Int( ByteIndex ) ..< Int( ByteIndex + character_count ) ] );
        ByteIndex += character_count;

        return String( bytes : byte_array, encoding : .utf8 ) ?? "";
    }

    // ~~

    func ReadName(
        ) -> String
    {
        var byte_array : [ UInt8 ];
        var character_count : UInt64;
        var natural : UInt64;
        var name : String;

        natural = ReadNatural64();

        if ( ( natural & 1 ) == 0 )
        {
            character_count = natural >> 1;
            byte_array = Array( ByteArray[ Int( ByteIndex ) ..< Int( ByteIndex + character_count ) ] );
            ByteIndex += character_count;

            name = String( bytes : byte_array, encoding : .utf8 ) ?? "";

            NameIndexDictionary[ name ] = UInt64( NameArray.count );
            NameArray.append( name );

            return name;
        }
        else
        {
            return NameArray[ Int( natural >> 1 ) ];
        }
    }

    // ~~

    func ReadByteCount(
        ) -> UInt64
    {
        return
            UInt64( ReadNatural8() )
            | ( UInt64( ReadNatural8() ) << 8 )
            | ( UInt64( ReadNatural8() ) << 16 )
            | ( UInt64( ReadNatural8() ) << 24 );
    }

    // ~~

    func ReadFieldHeader(
        _ field_name : String
        ) -> Bool
    {
        var byte_count : UInt64;
        var name : String;

        if ( StateArray[ StateArray.count - 1 ].SkippedFieldDictionary.count > 0 )
        {
            if let skipped_stream_field = StateArray[ StateArray.count - 1 ].SkippedFieldDictionary[ field_name ]
            {
                ByteIndex = skipped_stream_field.ByteIndex;
                byte_count = skipped_stream_field.ByteCount;

                StateArray.append( STREAM_STATE( ByteIndex + byte_count ) );

                return true;
            }
        }

        while ( ByteIndex < StateArray[ StateArray.count - 1 ].PostByteIndex )
        {
            name = ReadName();
            byte_count = ReadByteCount();

            if ( name == field_name )
            {
                StateArray.append( STREAM_STATE( ByteIndex + byte_count ) );

                return true;
            }
            else
            {
                StateArray[ StateArray.count - 1 ].SkippedFieldDictionary[ name ] = STREAM_FIELD( ByteIndex, byte_count );
                ByteIndex += byte_count;
            }
        }

        print( "Missing field : " + field_name );

        return false;
    }

    // ~~

    func ReadFieldFooter(
        )
    {
        ByteIndex = StateArray[ StateArray.count - 1 ].PostByteIndex;
        StateArray.removeLast();
    }

    // ~~

    func ReadField<_VALUE_ : STREAMABLE>(
        _ name : String,
        _ value : inout _VALUE_
        )
    {
        if ( ReadFieldHeader( name ) )
        {
            value.ReadValue( self );
            ReadFieldFooter();

            return true;
        }
        else
        {
            return false;
        }
    }

    // ~~

    func ReadField<_VALUE_ : STREAMABLE>(
        _ name : String,
        _ value_array : inout [ _VALUE_ ]
        )
    {
        var value : _VALUE_;
        var value_count : Int;

        if ( ReadFieldHeader( name ) )
        {
            value_count = Int( ReadNatural64() );
            value_array.removeAll();
            value_array.reserveCapacity( value_count );

            for _ in 0 ..< value_count
            {
                value = _VALUE_();
                value.ReadValue( self );
                value_array.append( value );
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

    func ReadField<_KEY_ : STREAMABLE, _VALUE_ : STREAMABLE>(
        _ name : String,
        _ value_dictionary : inout [ _KEY_ : _VALUE_ ]
        )
    {
        var key : _KEY_;
        var value : _VALUE_;
        var value_count : Int;

        if ( ReadFieldHeader( name ) )
        {
            value_count = Int( ReadNatural64() );
            value_dictionary.removeAll();
            value_dictionary.reserveCapacity( value_count );

            for _ in 0 ..< value_count
            {
                key = _KEY_();
                key.ReadValue( self );
                value = _VALUE_();
                value.ReadValue( self );
                value_dictionary[ key ] = value;
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

    func LoadFile(
        _ file_path : String
        )
    {
        SetByteArray( ReadByteArray( file_path ) );
    }
}

// -- FUNCTIONS

func WriteByteArray(
    _ file_path : String,
    _ byte_array : [ UInt8 ]
    )
{
    print( ":TODO: WriteByteArray" );
}

// ~~

func ReadByteArray(
    _ file_path : String
    ) -> [ UInt8 ]
{
    print( ":TODO: ReadByteArray" );

    return [];
}

// -- EXTENSIONS

extension Bool : STREAMABLE
{
    // -- OPERATIONS

    mutating func WriteValue(
        _ stream : STREAM
        )
    {
        stream.WriteBoolean( self );
    }

    // ~~

    mutating func ReadValue(
        _ stream : STREAM
        )
    {
        self = stream.ReadBoolean();
    }
}

// ~~

extension UInt8 : STREAMABLE
{
    // -- OPERATIONS

    mutating func WriteValue(
        _ stream : STREAM
        )
    {
        stream.WriteNatural8( self );
    }

    // ~~

    mutating func ReadValue(
        _ stream : STREAM
        )
    {
        self = stream.ReadNatural8();
    }
}

// ~~

extension UInt16 : STREAMABLE
{
    // -- OPERATIONS

    mutating func WriteValue(
        _ stream : STREAM
        )
    {
        stream.WriteNatural16( self );
    }

    // ~~

    mutating func ReadValue(
        _ stream : STREAM
        )
    {
        self = stream.ReadNatural16();
    }
}

// ~~

extension UInt32 : STREAMABLE
{
    // -- OPERATIONS

    mutating func WriteValue(
        _ stream : STREAM
        )
    {
        stream.WriteNatural32( self );
    }

    // ~~

    mutating func ReadValue(
        _ stream : STREAM
        )
    {
        self = stream.ReadNatural32();
    }
}

// ~~

extension UInt64 : STREAMABLE
{
    // -- OPERATIONS

    mutating func WriteValue(
        _ stream : STREAM
        )
    {
        stream.WriteNatural64( self );
    }

    // ~~

    mutating func ReadValue(
        _ stream : STREAM
        )
    {
        self = stream.ReadNatural64();
    }
}

// ~~

extension Int8 : STREAMABLE
{
    // -- OPERATIONS

    mutating func WriteValue(
        _ stream : STREAM
        )
    {
        stream.WriteInteger8( self );
    }

    // ~~

    mutating func ReadValue(
        _ stream : STREAM
        )
    {
        self = stream.ReadInteger8();
    }
}

// ~~

extension Int16 : STREAMABLE
{
    // -- OPERATIONS

    mutating func WriteValue(
        _ stream : STREAM
        )
    {
        stream.WriteInteger16( self );
    }

    // ~~

    mutating func ReadValue(
        _ stream : STREAM
        )
    {
        self = stream.ReadInteger16();
    }
}

// ~~

extension Int32 : STREAMABLE
{
    // -- OPERATIONS

    mutating func WriteValue(
        _ stream : STREAM
        )
    {
        stream.WriteInteger32( self );
    }

    // ~~

    mutating func ReadValue(
        _ stream : STREAM
        )
    {
        self = stream.ReadInteger32();
    }
}

// ~~

extension Int64 : STREAMABLE
{
    // -- OPERATIONS

    mutating func WriteValue(
        _ stream : STREAM
        )
    {
        stream.WriteInteger64( self );
    }

    // ~~

    mutating func ReadValue(
        _ stream : STREAM
        )
    {
        self = stream.ReadInteger64();
    }
}

// ~~

extension Float32 : STREAMABLE
{
    // -- OPERATIONS

    mutating func WriteValue(
        _ stream : STREAM
        )
    {
        stream.WriteReal32( self );
    }

    // ~~

    mutating func ReadValue(
        _ stream : STREAM
        )
    {
        self = stream.ReadReal32();
    }
}

// ~~

extension Float64 : STREAMABLE
{
    // -- OPERATIONS

    mutating func WriteValue(
        _ stream : STREAM
        )
    {
        stream.WriteReal64( self );
    }

    // ~~

    mutating func ReadValue(
        _ stream : STREAM
        )
    {
        self = stream.ReadReal64();
    }
}

// ~~

extension String : STREAMABLE
{
    // -- OPERATIONS

    mutating func WriteValue(
        _ stream : STREAM
        )
    {
        stream.WriteText( self );
    }

    // ~~

    mutating func ReadValue(
        _ stream : STREAM
        )
    {
        self = stream.ReadText();
    }
}
