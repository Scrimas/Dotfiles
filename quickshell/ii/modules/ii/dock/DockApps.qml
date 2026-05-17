import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.common.functions

Item {
    id: root
    property real maxWindowPreviewHeight: 200
    property real maxWindowPreviewWidth: 300
    property real windowControlsHeight: 30
    property real buttonPadding: 5

    property Item hoveredButton: null
    property Item lastHoveredButton: null
    property bool requestDockShow: previewPopup.visible

    Layout.fillHeight: true
    Layout.topMargin: Appearance.sizes.hyprlandGapsOut
    implicitWidth: listView.implicitWidth
    
    StyledListView {
        id: listView
        spacing: 2
        orientation: ListView.Horizontal
        anchors {
            top: parent.top
            bottom: parent.bottom
        }
        implicitWidth: contentWidth

        Behavior on implicitWidth {
            animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this)
        }

        model: ScriptModel {
            objectProp: "appId"
            values: TaskbarApps.apps
        }
        delegate: DockAppButton {
            required property var modelData
            appToplevel: modelData
            appListRoot: root

            topInset: Appearance.sizes.hyprlandGapsOut + root.buttonPadding
            bottomInset: Appearance.sizes.hyprlandGapsOut + root.buttonPadding
        }
    }

    PopupWindow {
        id: previewPopup
        property var appTopLevel: (root.hoveredButton || root.lastHoveredButton)?.appToplevel
        
        readonly property bool shouldShow: (root.hoveredButton != null || popupMouseArea.containsMouse) && appTopLevel && appTopLevel.toplevels.length > 0
        
        // Window visibility management
        property bool active: false
        onShouldShowChanged: {
            if (shouldShow) {
                activeTimer.stop();
                active = true;
            } else {
                activeTimer.restart();
            }
        }

        Timer {
            id: activeTimer
            interval: 210
            onTriggered: previewPopup.active = false
        }

        visible: active
        
        anchor {
            window: root.QsWindow.window
            adjustment: PopupAdjustment.None
            gravity: Edges.Top | Edges.Right
            edges: Edges.Top | Edges.Left
        }
        color: "transparent"
        implicitWidth: root.QsWindow.window?.width ?? 1
        implicitHeight: popupMouseArea.implicitHeight + root.windowControlsHeight + Appearance.sizes.elevationMargin * 2

        MouseArea {
            id: popupMouseArea
            anchors.bottom: parent.bottom
            implicitWidth: popupBackground.implicitWidth + Appearance.sizes.elevationMargin * 2
            implicitHeight: root.maxWindowPreviewHeight + root.windowControlsHeight + Appearance.sizes.elevationMargin * 2
            hoverEnabled: true
            
            // X position: Jump instantly to new position.
            x: {
                const itemCenter = root.QsWindow?.mapFromItem(root.lastHoveredButton, root.lastHoveredButton?.width / 2, 0);
                return (itemCenter?.x ?? 0) - width / 2
            }

            StyledRectangularShadow {
                target: popupBackground
                opacity: popupBackground.opacity
            }

            Rectangle {
                id: popupBackground
                property real padding: 5
                
                // Opacity fade
                opacity: previewPopup.shouldShow ? 1 : 0
                Behavior on opacity {
                    NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
                }

                // Vertical slide movement: slides UP from 15px down when appearing
                anchors.bottom: parent.bottom
                anchors.bottomMargin: Appearance.sizes.elevationMargin - (previewPopup.shouldShow ? 0 : 15)
                Behavior on anchors.bottomMargin {
                    NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
                }

                clip: true
                color: Appearance.m3colors.m3surfaceContainer
                radius: Appearance.rounding.normal
                anchors.horizontalCenter: parent.horizontalCenter
                
                // Resizing behavior: grows from 0 to full size when active
                implicitHeight: (previewPopup.active ? previewRowLayout.implicitHeight : 0) + padding * 2
                implicitWidth: (previewPopup.active ? previewRowLayout.implicitWidth : 0) + padding * 2
                Behavior on implicitWidth {
                    animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this)
                }
                Behavior on implicitHeight {
                    animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this)
                }

                RowLayout {
                    id: previewRowLayout
                    anchors.centerIn: parent
                    Repeater {
                        model: ScriptModel {
                            values: previewPopup.appTopLevel?.toplevels ?? []
                        }
                        RippleButton {
                            id: windowButton
                            required property var modelData
                            padding: 0
                            middleClickAction: () => {
                                windowButton.modelData?.close();
                            }
                            onClicked: {
                                windowButton.modelData?.activate();
                            }
                            contentItem: ColumnLayout {
                                implicitWidth: screencopyView.implicitWidth
                                implicitHeight: screencopyView.implicitHeight

                                ButtonGroup {
                                    contentWidth: parent.width - anchors.margins * 2
                                    StyledText {
                                        Layout.margins: 5
                                        Layout.fillWidth: true
                                        font.pixelSize: Appearance.font.pixelSize.small
                                        text: windowButton.modelData?.title
                                        elide: Text.ElideRight
                                        color: Appearance.m3colors.m3onSurface
                                    }
                                    GroupButton {
                                        id: closeButton
                                        colBackground: ColorUtils.transparentize(Appearance.colors.colSurfaceContainer)
                                        baseWidth: root.windowControlsHeight
                                        baseHeight: root.windowControlsHeight
                                        buttonRadius: Appearance.rounding.full
                                        contentItem: MaterialSymbol {
                                            anchors.centerIn: parent
                                            horizontalAlignment: Text.AlignHCenter
                                            text: "close"
                                            iconSize: Appearance.font.pixelSize.normal
                                            color: Appearance.m3colors.m3onSurface
                                        }
                                        onClicked: {
                                            windowButton.modelData?.close();
                                        }
                                    }
                                }
                                ScreencopyView {
                                    id: screencopyView
                                    captureSource: windowButton.modelData
                                    live: true
                                    paintCursor: true
                                    constraintSize: Qt.size(root.maxWindowPreviewWidth, root.maxWindowPreviewHeight)
                                    layer.enabled: true
                                    layer.effect: OpacityMask {
                                        maskSource: Rectangle {
                                            width: screencopyView.width
                                            height: screencopyView.height
                                            radius: Appearance.rounding.small
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
