import QtQuick
import QtQuick.Layouts
import qs.modules.common
import qs.modules.common.widgets

ColumnLayout {
    property alias time: timeText.text
    property alias temp: tempText.text
    property alias feels: feelsText.text
    property string wCode: "113"
    
    spacing: 5
    Layout.fillHeight: true
    Layout.preferredWidth: 60

    StyledText {
        id: timeText
        Layout.alignment: Qt.AlignHCenter
        font.pixelSize: Appearance.font.pixelSize.smaller
        color: Appearance.colors.colOnSurfaceVariant
        opacity: 0.8
    }

    MaterialSymbol {
        Layout.alignment: Qt.AlignHCenter
        text: Icons.getWeatherIcon(wCode) ?? "cloud"
        iconSize: Appearance.font.pixelSize.large
        color: Appearance.colors.colOnSurfaceVariant
    }

    StyledText {
        id: tempText
        Layout.alignment: Qt.AlignHCenter
        font {
            pixelSize: Appearance.font.pixelSize.small
            weight: Font.Medium
        }
        color: Appearance.colors.colOnSurfaceVariant
    }
    
    StyledText {
        id: feelsText
        Layout.alignment: Qt.AlignHCenter
        font.pixelSize: Appearance.font.pixelSize.smaller
        color: Appearance.colors.colOnSurfaceVariant
        opacity: 0.6
    }
}
