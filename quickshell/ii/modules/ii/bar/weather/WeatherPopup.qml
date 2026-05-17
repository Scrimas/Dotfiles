import qs.services
import qs.modules.common
import qs.modules.common.widgets

import QtQuick
import QtQuick.Layouts
import qs.modules.ii.bar

StyledPopup {
    id: root

    property int weekMin: {
        if (!Weather.data.daily || Weather.data.daily.length === 0) return 0;
        return Math.min(...Weather.data.daily.map(d => d.min));
    }
    property int weekMax: {
        if (!Weather.data.daily || Weather.data.daily.length === 0) return 100;
        return Math.max(...Weather.data.daily.map(d => d.max));
    }

    Item {
        x: 10
        y: 10
        implicitWidth: 480
        implicitHeight: mainLayout.implicitHeight + 40

        ColumnLayout {
            id: mainLayout
            width: parent.width
            anchors.top: parent.top
            anchors.topMargin: 20
            anchors.left: parent.left
            anchors.leftMargin: 20
            anchors.right: parent.right
            anchors.rightMargin: 20
            spacing: 15

            // --- SECTION 1: Current Weather ---
            RowLayout {
                Layout.fillWidth: true
                spacing: 0

                ColumnLayout {
                    spacing: 8
                    RowLayout {
                        spacing: 4
                        StyledText {
                            text: Weather.data.city
                            font {
                                pixelSize: Appearance.font.pixelSize.normal
                                weight: Font.Medium
                            }
                            color: Appearance.colors.colOnSurfaceVariant
                        }
                        MaterialSymbol {
                            text: "near_me"
                            iconSize: Appearance.font.pixelSize.smaller
                            color: Appearance.colors.colOnSurfaceVariant
                            opacity: 0.8
                        }
                    }

                    RowLayout {
                        spacing: 12
                        Layout.alignment: Qt.AlignLeft

                        // Large Temperature
                        StyledText {
                            text: Weather.data.temp
                            font {
                                pixelSize: 64
                                weight: Font.Light
                            }
                            color: Appearance.colors.colOnSurfaceVariant
                            Layout.alignment: Qt.AlignVCenter
                        }
                    }

                    StyledText {
                        text: Translation.tr("Feels like: %1").arg(Weather.data.tempFeelsLike)
                        font.pixelSize: Appearance.font.pixelSize.small
                        color: Appearance.colors.colOnSurfaceVariant
                        opacity: 0.9
                    }
                }

                Item { Layout.fillWidth: true }

                // --- CURRENT WEATHER DETAILS BLOCK ---
                ColumnLayout {
                    Layout.alignment: Qt.AlignCenter
                    spacing: 6

                    MaterialSymbol {
                        Layout.alignment: Qt.AlignHCenter
                        text: Icons.getWeatherIcon(Weather.data.wCode) ?? "cloud"
                        iconSize: 60
                        color: Appearance.colors.colOnSurfaceVariant
                        opacity: 0.9
                    }

                    ColumnLayout {
                        Layout.alignment: Qt.AlignHCenter
                        spacing: 2

                        // Line 1: High / Low
                        RowLayout {
                            Layout.alignment: Qt.AlignHCenter
                            spacing: 4
                            StyledText {
                                text: "H:"
                                font.pixelSize: 13
                                color: Appearance.colors.colOnSurfaceVariant
                                opacity: 1
                            }
                            StyledText {
                                text: Weather.data.high
                                font.pixelSize: 13
                                color: Appearance.colors.colOnSurfaceVariant
                                opacity: 1
                            }
                            StyledText {
                                text: "/"
                                font.pixelSize: 13
                                color: Appearance.colors.colOnSurfaceVariant
                                opacity: 1
                            }
                            StyledText {
                                text: "L:"
                                font.pixelSize: 13
                                color: Appearance.colors.colOnSurfaceVariant
                                opacity: 1
                            }
                            StyledText {
                                text: Weather.data.low
                                font.pixelSize: 13
                                color: Appearance.colors.colOnSurfaceVariant
                                opacity: 1
                            }
                        }

                        // Line 2: Sunrise
                        RowLayout {
                            Layout.alignment: Qt.AlignHCenter
                            spacing: 12
                            RowLayout {
                                spacing: 4
                                MaterialSymbol {
                                    text: "sunny"
                                    iconSize: 17
                                    color: Appearance.colors.colOnSurfaceVariant
                                    opacity: 1
                                }
                                StyledText {
                                    text: Weather.data.sunrise
                                    font.pixelSize: 13
                                    color: Appearance.colors.colOnSurfaceVariant
                                    opacity: 1
                                }
                            }
                        }

                        // Line 3: Sunset
                        RowLayout {
                            Layout.alignment: Qt.AlignCenter
                            spacing: 12
                            RowLayout {
                                spacing: 4
                                MaterialSymbol {
                                    text: "dark_mode"
                                    iconSize: 17
                                    color: Appearance.colors.colOnSurfaceVariant
                                    opacity: 1
                                }
                                StyledText {
                                    text: Weather.data.sunset
                                    font.pixelSize: 13
                                    color: Appearance.colors.colOnSurfaceVariant
                                    opacity: 1
                                }
                            }
                        }
                    }
                }

                Item { Layout.fillWidth: true }

                // --- DASHBOARD COMPONENT ---
                GridLayout {
                    columns: 3
                    rowSpacing: 0
                    columnSpacing: 0
                    Layout.alignment: Qt.AlignTop | Qt.AlignRight

                    // --- Row 1 ---
                    // Rain
                    ColumnLayout {
                        Layout.alignment: Qt.AlignCenter
                        Layout.margins: 10
                        MaterialSymbol {
                            Layout.alignment: Qt.AlignHCenter
                            text: "water_drop"
                            iconSize: 30
                            color: Appearance.colors.colOnSurfaceVariant
                            opacity: 1
                        }
                        StyledText {
                            Layout.alignment: Qt.AlignHCenter
                            text: Translation.tr("Rain: %1").arg(Weather.data.precipProb)
                            font.pixelSize: 11
                            color: Appearance.colors.colOnSurfaceVariant
                            opacity: 1
                        }
                    }

                    // Vertical Divider
                    Rectangle {
                        Layout.fillHeight: true
                        Layout.preferredWidth: 1
                        color: Appearance.colors.colOnSurfaceVariant
                        opacity: 0.2
                    }

                    // Wind
                    ColumnLayout {
                        Layout.alignment: Qt.AlignCenter
                        Layout.margins: 10
                        MaterialSymbol {
                            Layout.alignment: Qt.AlignHCenter
                            text: "air"
                            iconSize: 30
                            color: Appearance.colors.colOnSurfaceVariant
                            opacity: 1
                        }
                        StyledText {
                            Layout.alignment: Qt.AlignHCenter
                            text: Translation.tr("Wind: %1").arg(Weather.data.wind)
                            font.pixelSize: 11
                            color: Appearance.colors.colOnSurfaceVariant
                            opacity: 1
                        }
                    }

                    // Horizontal Divider
                    Rectangle {
                        Layout.columnSpan: 3
                        Layout.fillWidth: true
                        Layout.preferredHeight: 0.5
                        color: Appearance.colors.colOnSurfaceVariant
                        opacity: 0.2
                    }

                    // --- Row 2 ---
                    // Humidity
                    ColumnLayout {
                        Layout.alignment: Qt.AlignCenter
                        Layout.margins: 10
                        MaterialSymbol {
                            Layout.alignment: Qt.AlignHCenter
                            text: "humidity_percentage"
                            iconSize: 30
                            color: Appearance.colors.colOnSurfaceVariant
                            opacity: 1
                        }
                        StyledText {
                            Layout.alignment: Qt.AlignHCenter
                            text: Translation.tr("Humidity: %1").arg(Weather.data.humidity)
                            font.pixelSize: 11
                            color: Appearance.colors.colOnSurfaceVariant
                            opacity: 1
                        }
                    }

                    // Vertical Divider
                    Rectangle {
                        Layout.fillHeight: true
                        Layout.preferredWidth: 1
                        color: Appearance.colors.colOnSurfaceVariant
                        opacity: 0.2
                    }

                    // UV Index
                    ColumnLayout {
                        Layout.alignment: Qt.AlignCenter
                        Layout.margins: 10
                        MaterialSymbol {
                            Layout.alignment: Qt.AlignHCenter
                            text: "light_mode"
                            iconSize: 30
                            color: Appearance.colors.colOnSurfaceVariant
                            opacity: 1
                        }
                        StyledText {
                            Layout.alignment: Qt.AlignHCenter
                            text: Translation.tr("UV Index: %1").arg(Weather.data.uv)
                            font.pixelSize: 11
                            color: Appearance.colors.colOnSurfaceVariant
                            opacity: 1
                        }
                    }
                }
            }

            // --- SECTION 2: Hourly Strip ---
            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: Appearance.colors.colOutlineVariant
                opacity: 1
            }

            RowLayout {
                id: hourlyRow
                Layout.fillWidth: true
                spacing: 0

                Repeater {
                    model: Weather.data.hourly
                    delegate: WeatherHourlyItem {
                        Layout.fillWidth: true
                        time: modelData.time
                        wCode: modelData.icon
                        temp: modelData.temp
                        feels: modelData.feels
                    }
                }
            }

            // --- SECTION 3: Daily Forecast ---
            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: Appearance.colors.colOutlineVariant
                opacity: 1
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 8
                Repeater {
                    model: Weather.data.daily
                    delegate: WeatherDailyItem {
                        Layout.fillWidth: true
                        day: modelData.day
                        wCode: modelData.icon
                        min: modelData.min
                        max: modelData.max
                        weekMin: root.weekMin
                        weekMax: root.weekMax
                        currentTemp: (modelData.day === "Today") ? Weather.data.tempRaw : -999
                    }
                }
            }
        }

        // --- FOOTER: ---
        Item {
            anchors.top: mainLayout.bottom
            anchors.bottom: parent.bottom
            width: parent.width

            StyledText {
                anchors.centerIn: parent
                text: Translation.tr("Last refresh: %1").arg(Weather.data.lastRefresh)
                font {
                    weight: Font.Medium
                    pixelSize: 10
                }
                color: Appearance.colors.colOnSurfaceVariant
                opacity: 0.7
            }
        }
    }
}
