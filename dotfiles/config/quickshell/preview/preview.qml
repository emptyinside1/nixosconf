import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland
import "./modules/bar"
import "./modules/launcher"

ShellRoot {
    Bar {
        id: bar
    }
    
    Launcher {
        id: launcher
    }

    // Allow toggling the launcher from the command line:
    // quickshell --ipc "launcher.toggle()"
    IpcHandler {
        target: "launcher"
        
        function toggle() {
            launcher.visible = !launcher.visible;
            if (launcher.visible) {
                launcher.focus = true;
            }
        }
        
        function open() {
            launcher.visible = true;
            launcher.focus = true;
        }
        
        function close() {
            launcher.visible = false;
        }
    }
}
