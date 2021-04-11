// -- IMPORTS

import SwiftUI;

// -- TYPES

typealias IDENTIFIER = UUID;

// ~~

extension UUID : STREAMABLE
{
    // -- OPERATIONS

    mutating func WriteValue(
        _ stream : STREAM
        )
    {
        var first_byte : UInt8,
            second_byte : UInt8,
            third_byte : UInt8,
            fourth_byte : UInt8,
            fifth_byte : UInt8,
            sixth_byte : UInt8,
            seventh_byte : UInt8,
            eighth_byte : UInt8,
            ninth_byte : UInt8,
            tenth_byte : UInt8,
            eleventh_byte : UInt8,
            twelfth_byte : UInt8,
            thirteenth_byte : UInt8,
            fourteenth_byte : UInt8,
            fifteenth_byte : UInt8,
            sixteenth_byte : UInt8;

        ( first_byte, second_byte, third_byte, fourth_byte,
          fifth_byte, sixth_byte, seventh_byte, eighth_byte,
          ninth_byte, tenth_byte, eleventh_byte, twelfth_byte,
          thirteenth_byte, fourteenth_byte, fifteenth_byte, sixteenth_byte ) = self.uuid;

        stream.WriteNatural8( first_byte );
        stream.WriteNatural8( second_byte );
        stream.WriteNatural8( third_byte );
        stream.WriteNatural8( fourth_byte );
        stream.WriteNatural8( fifth_byte );
        stream.WriteNatural8( sixth_byte );
        stream.WriteNatural8( seventh_byte );
        stream.WriteNatural8( eighth_byte );
        stream.WriteNatural8( ninth_byte );
        stream.WriteNatural8( tenth_byte );
        stream.WriteNatural8( eleventh_byte );
        stream.WriteNatural8( twelfth_byte );
        stream.WriteNatural8( thirteenth_byte );
        stream.WriteNatural8( fourteenth_byte );
        stream.WriteNatural8( fifteenth_byte );
        stream.WriteNatural8( sixteenth_byte );
    }

    // ~~

    mutating func ReadValue(
        _ stream : STREAM
        )
    {
        var first_byte : UInt8,
            second_byte : UInt8,
            third_byte : UInt8,
            fourth_byte : UInt8,
            fifth_byte : UInt8,
            sixth_byte : UInt8,
            seventh_byte : UInt8,
            eighth_byte : UInt8,
            ninth_byte : UInt8,
            tenth_byte : UInt8,
            eleventh_byte : UInt8,
            twelfth_byte : UInt8,
            thirteenth_byte : UInt8,
            fourteenth_byte : UInt8,
            fifteenth_byte : UInt8,
            sixteenth_byte : UInt8;

        first_byte = stream.ReadNatural8();
        second_byte = stream.ReadNatural8();
        third_byte = stream.ReadNatural8();
        fourth_byte = stream.ReadNatural8();
        fifth_byte = stream.ReadNatural8();
        sixth_byte = stream.ReadNatural8();
        seventh_byte = stream.ReadNatural8();
        eighth_byte = stream.ReadNatural8();
        ninth_byte = stream.ReadNatural8();
        tenth_byte = stream.ReadNatural8();
        eleventh_byte = stream.ReadNatural8();
        twelfth_byte = stream.ReadNatural8();
        thirteenth_byte = stream.ReadNatural8();
        fourteenth_byte = stream.ReadNatural8();
        fifteenth_byte = stream.ReadNatural8();
        sixteenth_byte = stream.ReadNatural8();

        self
            = UUID(
                  uuid: ( first_byte, second_byte, third_byte, fourth_byte,
                          fifth_byte, sixth_byte, seventh_byte, eighth_byte,
                          ninth_byte, tenth_byte, eleventh_byte, twelfth_byte,
                          thirteenth_byte, fourteenth_byte, fifteenth_byte, sixteenth_byte )
                  );

    }
}
