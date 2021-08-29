module bif.stream_state;

// -- IMPORTS

import bif.stream_field;

// -- TYPES

struct STREAM_STATE
{
    // -- ATTRIBUTES

    ulong
        PostByteIndex = 0;
    STREAM_FIELD[ string ]
        SkippedFieldDictionary = null;

    // -- CONSTRUCTORS

    this(
        ulong post_byte_index
        )
    {
        PostByteIndex = post_byte_index;
        SkippedFieldDictionary = null;
    }
}
