import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import "../.."

PanelWindow {
    id: launcher
    screen: Quickshell.screens[0]
    implicitWidth: screen.width / screen.scale * 0.4
    implicitHeight: 500
    
    // Positioned centered by not specifying any anchors.
    anchors {
        top: false
        bottom: false
        left: false
        right: false
    }
    
    visible: false
    
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "quickshell:launcher"
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
    
    color: "transparent"

    // Key handler item to avoid warnings on PanelWindow
    Item {
        id: keyHandler
        anchors.fill: parent
        focus: launcher.visible

        // Background matching Rofi
        Rectangle {
            id: mainRect
            anchors.fill: parent
            color: "#1a1a1aee" // Increased opacity for readability
            radius: 0
            border.color: Colors.accentPrimary
            border.width: 1

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 15
                spacing: 12

                // Input bar mimicking Rofi's look
                TextField {
                    id: searchInput
                    Layout.fillWidth: true
                    placeholderText: "Search Applications..."
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 15
                    font.weight: Font.DemiBold
                    color: Colors.primaryText
                    focus: launcher.visible
                    
                    background: Rectangle {
                        color: "transparent"
                        border.color: searchInput.activeFocus ? Colors.accentPrimary : Colors.borderSecondary
                        border.width: 1
                    }
                    
                    onTextChanged: {
                        appList.model = Array.from(DesktopEntries.applications.values)
                            .filter(app => app.name.toLowerCase().includes(text.toLowerCase()));
                    }
                    
                    onAccepted: {
                        if (appList.model.length > 0) {
                            appList.model[0].launch();
                            launcher.visible = false;
                        }
                    }
                }

                // List of apps
                ListView {
                    id: appList
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true
                    model: DesktopEntries.applications.values
                    
                    delegate: ItemDelegate {
                        width: appList.width
                        height: 48
                        padding: 8
                        
                        highlighted: ListView.isCurrentItem
                        
                        background: Rectangle {
                            color: highlighted ? Colors.accentPrimary : "transparent"
                            radius: 4
                        }
                        
                        contentItem: RowLayout {
                            spacing: 12
                            Image {
                                source: Quickshell.iconPath(modelData.icon)
                                Layout.preferredWidth: 32
                                Layout.preferredHeight: 32
                                asynchronous: true
                            }
                            Text {
                                text: modelData.name
                                color: highlighted ? Colors.accentPrimaryText : Colors.primaryText
                                font.family: "JetBrainsMono Nerd Font"
                                font.pixelSize: 14
                                font.weight: Font.Medium
                                verticalAlignment: Text.AlignVCenter
                            }
                        }
                        
                        onClicked: {
                            modelData.launch();
                            launcher.visible = false;
                        }
                    }
                    
                    ScrollBar.vertical: ScrollBar {
                        policy: ScrollBar.AsNeeded
                        active: true
                    }
                }
            }
        }
        
        // Global key handler for the window
        Keys.onPressed: event => {
            if (event.key === Qt.Key_Escape) {
                launcher.visible = false;
            } else if (event.key === Qt.Key_Down) {
                appList.incrementCurrentIndex();
            } else if (event.key === Qt.Key_Up) {
                appList.decrementCurrentIndex();
            } else if (event.key === Qt.Key_Return && appList.currentItem) {
                appList.model[appList.currentIndex].launch();
                launcher.visible = false;
            }
        }
    }
}
