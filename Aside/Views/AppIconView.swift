import SwiftUI

#if os(iOS)
import UIKit
typealias PlatformImage = UIImage

func getAppIcon() -> PlatformImage? {
    guard let iconsDictionary = Bundle.main.infoDictionary?["CFBundleIcons"] as? [String: Any],
          let primaryIcons = iconsDictionary["CFBundlePrimaryIcon"] as? [String: Any],
          let iconFiles = primaryIcons["CFBundleIconFiles"] as? [String],
          let lastIcon = iconFiles.last else {
        return nil
    }

    return UIImage(named: lastIcon)
}

#elseif os(macOS)
import AppKit
typealias PlatformImage = NSImage

func getAppIcon() -> PlatformImage? {
    // Use system app icon image on macOS
    return NSApplication.shared.applicationIconImage
}
#endif

struct AppIconView: View {
    var body: some View {
        if let icon = getAppIcon() {
            Group {
                #if os(iOS)
                Image(uiImage: icon)
                    .resizable()
                #elseif os(macOS)
                Image(nsImage: icon)
                    .resizable()
                #endif
            }
            .clipShape(RoundedRectangle(cornerRadius: 4))
        }
    }
}
