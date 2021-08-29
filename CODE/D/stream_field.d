module bif.stream_field;

// -- TYPES

struct STREAM_FIELD
{
    // -- ATTRIBUTES

    ulong
        ByteIndex = 0,
        ByteCount = 0;

    // -- CONSTRUCTORS

    this(
        ulong byte_index,
        ulong byte_count
        )
    {
        ByteIndex = byte_index;
        ByteCount = byte_count;
    }
}
