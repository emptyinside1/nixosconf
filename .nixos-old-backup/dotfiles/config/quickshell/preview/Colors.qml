pragma Singleton
import QtQuick
import Qt.labs.platform
import Quickshell
import Quickshell.Io

Singleton {
    id: colors
    property var values: ({})
    
    // Default values in case the file is missing or unreadable
    readonly property color windowBackground: values.windowBackground || "#0f0f15"
    readonly property color primaryText: values.primaryText || "#bac2de"
    readonly property color layerBackground1: values.layerBackground1 || "#1F1A1F"
    readonly property color layerBackground2: values.layerBackground2 || "#231E23"
    readonly property color layerBackground3: values.layerBackground3 || "#2D282E"
    readonly property color surfaceText: values.surfaceText || "#EAE0E7"
    readonly property color secondaryText: values.secondaryText || "#CFC3CD"
    readonly property color borderPrimary: values.borderPrimary || "#cba6f7"
    readonly property color shadowColor: values.shadowColor || "#000000"
    readonly property color accentPrimary: values.accentPrimary || "#6750A4"
    readonly property color accentSecondary: values.accentSecondary || "#D5C0D7"
    readonly property color selectionBackground: values.selectionBackground || "#534457"
    readonly property color accentPrimaryText: values.accentPrimaryText || "#FFFFFF"
    readonly property color selectionText: values.selectionText || "#F2DCF3"
    readonly property color borderSecondary: values.borderSecondary || "#4C444D"

    FileView {
        id: colorFile
        // Using StandardPaths to find the generated colors in ~/.config/quickshell/
        path: StandardPaths.standardLocations(StandardPaths.ConfigLocation)[0] + "/quickshell/qml_color.json"
        watchChanges: true
        onLoadedChanged: {
            if (loaded) {
                try {
                    colors.values = JSON.parse(text());
                } catch (e) {
                    console.error("[Colors] Failed to parse qml_color.json: " + e);
                }
            }
        }
    }
}
