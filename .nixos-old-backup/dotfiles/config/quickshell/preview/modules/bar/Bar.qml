import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import "../.."

PanelWindow {
    id: bar
    screen: Quickshell.screens[0] // Primary monitor
    // Anchoring to the top. Centering will be handled by Hyprland when left/right are false.
    anchors {
        top: true
        left: false
        right: false
    }
    
    // Waybar settings from config
    implicitWidth: 1050
    implicitHeight: 38 
    margins {
        top: 3
    }
    
    color: "transparent"
    WlrLayershell.layer: WlrLayer.Top
    WlrLayershell.namespace: "quickshell:bar"

    // Background container with blur and transparency
    Rectangle {
        id: bg
        anchors.fill: parent
        color: "#1a1a1a99" // Transparent background
        radius: 1 
        border.color: Colors.borderSecondary
        border.width: 1
        
        RowLayout {
            anchors.fill: parent
            anchors.margins: 4
            spacing: 15

            // Left: Clock, Weather
            RowLayout {
                Layout.alignment: Qt.AlignLeft
                spacing: 12
                
                Text {
                    id: clockText
                    text: Qt.formatDateTime(new Date(), "HH:mm:ss")
                    color: Colors.primaryText
                    font.family: "JetBrainsMono Nerd Font"
                    font.weight: Font.Bold
                    font.pixelSize: 15
                    
                    Timer {
                        interval: 1000
                        repeat: true
                        running: true
                        onTriggered: clockText.text = Qt.formatDateTime(new Date(), "HH:mm:ss")
                    }
                }
                
                Text {
                    text: " 22°C" // Mock weather
                    color: Colors.primaryText
                    font.family: "JetBrainsMono Nerd Font"
                    font.weight: Font.Bold
                    font.pixelSize: 15
                }
            }

            // Center: Workspaces
            RowLayout {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignCenter
                spacing: 8
                
                Repeater {
                    model: Hyprland.workspaces
                    delegate: Rectangle {
                        property bool isActive: Hyprland.focusedMonitor?.activeWorkspace?.id === modelData.id
                        Layout.preferredWidth: isActive ? 35 : 25
                        Layout.preferredHeight: 25
                        radius: isActive ? 15 : 9
                        color: isActive ? Colors.accentPrimary : "transparent"
                        border.color: isActive ? "transparent" : Colors.borderPrimary
                        border.width: isActive ? 0 : 1
                        
                        Text {
                            anchors.centerIn: parent
                            text: modelData.id
                            color: isActive ? Colors.accentPrimaryText : Colors.primaryText
                            font.family: "JetBrainsMono Nerd Font"
                            font.weight: Font.Bold
                            font.pixelSize: 13
                        }
                        
                        Behavior on Layout.preferredWidth { NumberAnimation { duration: 300; easing.type: Easing.OutCubic } }
                        Behavior on radius { NumberAnimation { duration: 300 } }
                    }
                }
            }

            // Right: Status Icons
            RowLayout {
                Layout.alignment: Qt.AlignRight
                spacing: 12
                
                Text {
                    text: ""
                    color: Colors.primaryText
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 16
                }
                Text {
                    text: ""
                    color: Colors.primaryText
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 16
                }
                Text {
                    text: ""
                    color: Colors.primaryText
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 16
                }
                Text {
                    text: ""
                    color: Colors.accentPrimary
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 16
                }
            }
        }
    }
}
