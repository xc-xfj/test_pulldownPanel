/*
 * Copyright (C) 2020 ~ 2021 Uniontech Software Technology Co.,Ltd.
 *
 * Author:     ganjing <ganjing@uniontech.com>
 *
 * Maintainer: ganjing <ganjing@uniontech.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.9
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.Window 2.2

Window {
    id: statusBar

    color: "transparent"
    flags: Qt.WindowStaysOnTopHint | Qt.FramelessWindowHint | Qt.X11BypassWindowManagerHint & ~Qt.WindowMaximizeButtonHint
    visible: true
    x: 0
    y: 0
    width: Screen.width
    height: 40
    title: "due-statusbar"

    MouseArea {
        id: mouseArea

        // 滑屏动画
        /*! 第一次点击y坐标 */
        property int pressY: 0
        /*! 拖动总距离 */
        property int pressChangedY: 0
        /*! 每次拖动启始y坐标　*/
        property int lastTimeY: 0
        /*! 每次拖动距离 */
        property int lastTimeChangedY: 0
        property int distance: PulldownManager.distance()

        anchors.fill: parent
        enabled: !PulldownManager.isVisible()

        onPressed: {
            lastTimeY = mouseY
            pressY = mouseY
        }

        onMouseYChanged: {
            // 边缘划入才拉起下拉面板，锁定及关机界面不唤起下拉面板
            if (pressY - distance > 0)
                return

            lastTimeChangedY = mouseY - lastTimeY   // 每次拖动距离
            lastTimeY = mouseY                      // 每次拖动启始坐标
            pressChangedY = mouseY - pressY         // 拖动总距离

            PulldownManager.moveDown(pressChangedY)
        }

        onReleased: {
            if (pressY - distance > 0)
                return

            if (lastTimeChangedY > Screen.height * 0.01) {
                // 显示界面
                pressChangedY = 0
            } else if (lastTimeChangedY < -Screen.height * 0.01) {
                // 隐藏界面
                pressChangedY = -Screen.height
            } else {
                // 超过屏幕一半显示，否则隐藏界面
                pressChangedY = (mouseY > (Screen.height / 2)) ? 0 : -Screen.height
            }

            if (0 === pressChangedY) {
                PulldownManager.swipeDown()
            } else {
                PulldownManager.swipeUp()
            }

            // 清除历史数据
            lastTimeChangedY = pressChangedY = lastTimeY = pressY = 0
        }

        Connections {
            target: PulldownManager

            onVisibleChanged: {
                mouseArea.enabled = !PulldownManager.isVisible()
                if (PulldownManager.isVisible()) {
                    statusBar.raise()
                }
            }
        }
    }

    Item {
        id: statusBarRect

        anchors.fill: parent
    }
}
