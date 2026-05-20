pragma Singleton
import qs.modules.common
import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Io

/**
 * A nice wrapper for date and time strings.
 */
Singleton {
    id: root

    property bool inhibit: false

    Connections {
        target: Persistent
        function onReadyChanged() {
            if (!Persistent.isNewHyprlandInstance) {
                root.inhibit = Persistent.states.idle.inhibit;
            } else {
                Persistent.states.idle.inhibit = root.inhibit;
            }
        }
    }

    function toggleInhibit(active = null) {
        if (active !== null) {
            root.inhibit = active;
        } else {
            root.inhibit = !root.inhibit;
        }
        Persistent.states.idle.inhibit = root.inhibit;
    }

    Process {
        id: inhibitProc
        command: ["systemd-inhibit", "--what=handle-lid-switch", "--why=Keep system awake", "--mode=block", "sleep", "infinity"]
    }

    onInhibitChanged: {
        inhibitProc.running = inhibit;
    }

    Component.onCompleted: {
        inhibitProc.running = inhibit;
    }

    IpcHandler {
        target: "idleService"

        function toggle(): void {
            root.toggleInhibit();
        }

        function setInhibit(value: bool): void {
            root.toggleInhibit(value);
        }
    }
}
