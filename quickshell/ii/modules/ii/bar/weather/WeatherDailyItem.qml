import QtQuick
import QtQuick.Layouts
import qs.modules.common
import qs.modules.common.widgets

RowLayout {
    property alias day: dayText.text
    property string wCode: "113"
    property int min: 0
    property int max: 0
    property int weekMin: -100
    property int weekMax: 100
    property int currentTemp: -999

    spacing: 15
    Layout.fillWidth: true

    StyledText {
        id: dayText
        Layout.preferredWidth: 40
        font {
            pixelSize: Appearance.font.pixelSize.normal
            weight: Font.Medium
        }
        color: Appearance.colors.colOnSurfaceVariant
    }

    MaterialSymbol {
        text: Icons.getWeatherIcon(wCode) ?? "cloud"
        iconSize: Appearance.font.pixelSize.large
        color: Appearance.colors.colOnSurfaceVariant
    }

    StyledText {
        text: min + "°"
        Layout.preferredWidth: 30
        font.pixelSize: Appearance.font.pixelSize.normal
        color: Appearance.colors.colOnSurfaceVariant
        opacity: 0.7
        horizontalAlignment: Text.AlignRight
    }

    // Temperature Range Bar
    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: 4
        radius: 2
        color: Appearance.colors.colSurfaceContainerHigh

        Rectangle {
            id: rangeBar
            height: parent.height
            radius: 2

            // Scaling logic
            property real totalRange: weekMax - weekMin
            x: totalRange > 0 ? ((min - weekMin) / totalRange) * parent.width : 0
            width: totalRange > 0 ? ((max - min) / totalRange) * parent.width : parent.width

            gradient: Gradient {
                orientation: Gradient.Horizontal
                GradientStop { position: 0.0; color: "#ff9900" }
                GradientStop { position: 1.0; color: "#ff5500" }
            }
        }

        // Current Temp Slider Thumb
        Item {
            visible: currentTemp !== -999
            width: 12
            height: 12
            anchors.verticalCenter: parent.verticalCenter

            property real totalRange: weekMax - weekMin
            x: totalRange > 0 ? ((currentTemp - weekMin) / totalRange) * parent.width - (width / 2) : 0

            // Drop Shadow
            Rectangle {
                anchors.centerIn: parent
                width: parent.width + 2
                height: parent.height + 2
                radius: width / 2
                color: "#000000"
                opacity: 0.15
            }

            // Main Thumb
            Rectangle {
                anchors.fill: parent
                radius: width / 2
                color: "#ffffff"
                border.color: "#ff7700"
                border.width: 2
            }
        }
    }

    StyledText {
        text: max + "°"
        Layout.preferredWidth: 30
        font {
            pixelSize: Appearance.font.pixelSize.normal
            weight: Font.Medium
        }
        color: Appearance.colors.colOnSurfaceVariant
        horizontalAlignment: Text.AlignRight
    }
}
