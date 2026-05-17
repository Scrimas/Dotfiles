pragma Singleton
pragma ComponentBehavior: Bound

import qs.modules.common
import qs.modules.common.functions
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property int maxBrightness: 3
    property int rawBrightness: 0
    property real brightness: rawBrightness / maxBrightness
    property bool ready: false

    Component.onCompleted: {
        updateProc.running = true;
    }

    Timer {
        id: pollTimer
        interval: 50
        repeat: true
        running: true
        onTriggered: {
            if (!updateProc.running && !setProc.running) {
                updateProc.running = true;
            }
        }
    }

    Process {
        id: updateProc
        command: ["brightnessctl", "--device=samsung-galaxybook::kbd_backlight", "get"]
        stdout: StdioCollector {
            onStreamFinished: {
                const current = parseInt(text.trim());
                if (!isNaN(current)) {
                    if (root.ready && current !== root.rawBrightness) {
                        root.rawBrightness = current;
                    } else if (!root.ready) {
                        root.rawBrightness = current;
                        root.ready = true;
                    }
                }
            }
        }
    }

    Process {
        id: setProc
    }

    function setRawBrightness(value: int): void {
        value = Math.max(0, Math.min(root.maxBrightness, value));
        if (value === root.rawBrightness) return;
        root.rawBrightness = value;
        setProc.exec(["brightnessctl", "--device=samsung-galaxybook::kbd_backlight", "set", value.toString()]);
    }

    function increaseBrightness(): void {
        setRawBrightness(root.rawBrightness + 1);
    }

    function decreaseBrightness(): void {
        setRawBrightness(root.rawBrightness - 1);
    }

    function cycle(): void {
        let next = root.rawBrightness + 1;
        if (next > root.maxBrightness) next = 0;
        setRawBrightness(next);
    }

    IpcHandler {
        target: "kbd_brightness"

        function increment() {
            root.increaseBrightness();
        }

        function decrement() {
            root.decrementBrightness();
        }

        function cycle() {
            root.cycle();
        }
    }
}
