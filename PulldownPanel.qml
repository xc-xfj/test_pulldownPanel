/*
 * Copyright (C) 2020 ~ 2021 Uniontech Software Technology Co.,Ltd.
 *
 * Author:     xiechuan <xiechuan@uniontech.com>
 *
 * Maintainer: xiechuan <xiechuan@uniontech.com>
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

import QtQuick 2.11
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.11
import QtQuick.Window 2.11
import QtGraphicalEffects 1.0
//import com.deepin.dtk 1.0
//import EnumType 1.0
//import "../notification"
//import "../common"
//import "../statusBar/"
//import "../common/PixelMetrics.js" as CONST

Item {
    /*! 在19620*1080显示器上通知中心和快捷面板宽度分别为594和340，
    屏幕大小改变后，快捷面板宽度保持固定不变
    其边距和中间间隔，以及通知中心应该以一定的比例进行伸缩 */
    /*! 通知中心最大宽度 */
    readonly property int maxNotificationCenterWidth: 600
    readonly property int minNotificationCenterWidth: 500
    /*! 基准宽度，以1920*1080来调整通知中心和快捷设置的大小 */
    readonly property int baseScreenWidth: 1920
    /*! 快捷面板宽度 */
    readonly property int shortcutPanelWidth: 340
    /*! 通知中心和快捷面板固定上边距*/
    readonly property int fixedTopMargain: 60
    /*! 最小通知中心x坐标 */
    readonly property int miniNotificationX: 140
    /*! 通知中心和快捷面板最大间隔距离 */
    readonly property int maxSeparateWidth: 160
    /*! 通知中心和快捷面板最小间隔距离 */
    readonly property int minSeparateWidth: 50
    /*! 最小右边距 */
    readonly property int miniRightMargain: 140
    /*! 通知中心宽度 */
    property int notificationCenterWidth: 594
    /*! 通知中心和快捷面板间隔距离 */
    property int separateWidth: 160
    /*! 左边距 */
    property int leftMargain: 413
    property int rightMargain: 413

    property alias imageSource: image.source

    // 考虑到通知中心会被隐藏，但是需要占据空间的情况，暂不用布局进行控件管理，
    // 直接手动计算坐标，再确定控件位置
    anchors {
        left: parent.left
        right: parent.right
    }

    FastBlur {
        id: blurBack

        anchors.fill: image
        source: image
        radius: 50
    }

    ShaderEffectSource {
        id: blurEffectSource

        sourceItem: blurBack
        anchors.fill: blurBack
        hideSource: true
    }

    Image {
        id: image

        source: imagePath
        sourceSize: Qt.size(parent.width, parent.height)
        fillMode: Image.PreserveAspectFit
        visible: false
        cache: false
        asynchronous: true
    }

    Rectangle {
        anchors.fill: parent
        color: Qt.rgba(25 / 255, 25 / 255, 25 / 255, 0.3)
    }
}
