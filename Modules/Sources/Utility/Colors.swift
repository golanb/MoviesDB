//
//  File.swift
//  
//
//  Created by Golan Bar-Nov on 21/04/2024.
//

import SwiftUI

public struct ThemeColor {
    public let action = ActionColors()
    public let background = BackgroundColors()
    public let label = LabelColors()
}

public struct ActionColors {
    public let primary = Color("actions/primary", bundle: .module)
    public let secondary = Color("actions/secondary", bundle: .module)
    public let inactive = Color("actions/inactive", bundle: .module)
}

public struct BackgroundColors {
    public let primary = Color("backgrounds/primary", bundle: .module)
    public let secondary = Color("backgrounds/secondary", bundle: .module)
}

public struct LabelColors {
    public let primary = Color("labels/primary", bundle: .module)
    public let secondary = Color("labels/secondary", bundle: .module)
}

extension Color {
    public static var theme: ThemeColor { ThemeColor() }
}

