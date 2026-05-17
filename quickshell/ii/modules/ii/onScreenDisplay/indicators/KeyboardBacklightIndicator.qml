import qs.services
import QtQuick
import qs.modules.ii.onScreenDisplay

OsdValueIndicator {
    id: root
    value: KeyboardBacklight.brightness
    icon: "keyboard"
    name: Translation.tr("Keyboard")
}
