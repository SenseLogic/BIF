// -- IMPORTS

import SwiftUI

// -- EXTENSIONS

extension Float64
{
    // -- INQUIRIES
    
    func IsRoughlyZero(
        ) -> Bool
    {
        return self > -0.0000001 && self < 0.0000001;
    }
    
    // ~~
    
    func IsRoughlyOne(
        ) -> Bool
    {
        return self > 0.9999999 && self < 1.0000001;
    }
}
