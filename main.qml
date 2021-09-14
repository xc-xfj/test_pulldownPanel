
import QtQuick 2.11
import QtQuick.Window 2.2
import QtGraphicalEffects 1.0
//import QtQuick.Controls 2.4

Window {
    id: window

    // 滑屏动画
    /*! 第一次点击y坐标 */
    property int pressY: 0
    /*! 拖动总距离 */
    property int pressChangedY: 0
    /*! 每次拖动启始y坐标　*/
    property int lastTimeY: 0
    /*! 每次拖动距离 */
    property int lastTimeChangedY: 0
    /*! 上拉动画时间 */
    readonly property int animationTime: 200
    /*! 背景图片路径 */
    property string imagePath: "image://screenImage"

    function showpulldownPanel() {
        window.visible = true
        pulldownPanel.visible = true
        PulldownManager.setVisible(true)
        pullDownAnimation.running = true
    }

    function togglepulldownPanel() {
        if (pulldownPanel.y === 0) {
            pullupAnimation.running = true
        } else {
            showpulldownPanel()
        }
    }

    /*! 在快捷面板打开部分应用时, 需要收起下拉面板 */
    function hidepulldownPanel() {
        pullupAnimation.start()
    }

    x: 0
    y: 0
    width: Screen.width
    height: Screen.height
    minimumWidth: Screen.width
    minimumHeight: Screen.height
    visible: false
    color: "transparent"
    flags: Qt.FramelessWindowHint | Qt.X11BypassWindowManagerHint
    title: "due-pulldownpanel"


    // 滑动下拉面板的触碰区域，为了不阻碍子层qml的鼠标事件，故将此区域放到前面
    MouseArea {
        id: mouseArea

        anchors.fill: parent

        onPressed: {

            if (aniPullingBack.running)
                return

            lastTimeY = mouseY
            pressY = mouseY
        }

        onMouseYChanged: {
            if (aniPullingBack.running)
                return

            lastTimeChangedY = mouseY - lastTimeY // 每次拖动距离
            lastTimeY = mouseY　// 每次拖动启始坐标
            pressChangedY = mouseY - pressY　// 拖动总距离
            pulldownPanel.y = pressChangedY > 0 ? 0 : pressChangedY
        }

        onReleased: {
            if (aniPullingBack.running)
                return

            if (lastTimeChangedY > Screen.height * 0.01) {
                // 显示界面
                pressChangedY = 0
            } else if (lastTimeChangedY < -Screen.height * 0.01) {
                // 隐藏界面
                pressChangedY = -pulldownPanel.height
            } else {
                // 超过屏幕一半显示，否则隐藏界面
                pressChangedY = pulldownPanel.y > -pulldownPanel.height / 2 ? 0 : -pulldownPanel.height
            }
            aniPullingBack.start()
        }
    }

    // 下拉面板相关界面
    PulldownPanel {
        id: pulldownPanel

        x: 0
        y: -Screen.height
        width: Screen.width
        height: Screen.height
        visible: false
        Accessible.role: Accessible.Form
        Accessible.name: "form_pulldownpanel"
    }

    // 下划动画
    YAnimator {
        id: pullDownAnimation

        target: pulldownPanel
        from: pulldownPanel.y
        to: 0
        duration: animationTime

        // 锁屏或解锁状态下时唤起下拉面板时需要隐藏通知中心
        onStarted: {
            pulldownPanel.imageSource = imagePath
        }

        onStopped: {
            pulldownPanel.visible = true
            window.visible = true

            // 下划动画完成后下拉面板处于显示状态，开始处理触摸事件
            mouseArea.enabled = true
        }
    }

    // 上划动画
    YAnimator {
        id: pullupAnimation

        target: pulldownPanel
        from: pulldownPanel.y
        to: -Screen.height
        duration: animationTime

        onStopped: {
            pulldownPanel.visible = false
            window.visible = false
            // 收起下拉面板后需要重置背景图片路径
            pulldownPanel.imageSource = ""

            // 上划动画完成后下拉面板处于隐藏状态，不处理触摸事件
            mouseArea.enabled = false
            PulldownManager.setVisible(false)
        }
    }

    // 手指释放动画
    YAnimator {
        id: aniPullingBack

        target: pulldownPanel
        from: pulldownPanel.y
        to: pressChangedY
        easing.type: Easing.InOutCubic
        duration: animationTime
        running: false

        onStopped: {
            if (pressChangedY !== 0) {
                pulldownPanel.visible = false
                window.visible = false
                // 重置背景图片路径
                pulldownPanel.imageSource = ""

                mouseArea.enabled = false
                PulldownManager.setVisible(pulldownPanel.visible)
            }


        }
    }

    Connections {
        target: PulldownManager

        onSwipeDown: {
            if (pullupAnimation.running)
                return

            if (pulldownPanel.y !== 0) {
                // 执行动画过程中默认下拉面板处于显示状态，不处理触摸事件
                mouseArea.enabled = false

                showpulldownPanel()
            }
        }

        onSwipeUp: {
            if (pullDownAnimation.running)
                return

            if (pulldownPanel.y !== -Screen.height) {
                // 执行动画过程中默认下拉面板处于显示状态，不处理触摸事件
                mouseArea.enabled = false

                pullupAnimation.running = true
            }
        }

        onToggled: {
            // 执行动画过程中默认下拉面板处于显示状态，不处理触摸事件
            mouseArea.enabled = false

            togglepulldownPanel()
        }

        onMoveDown: {
            // 下拉面板显示完全或滑动距离为0，不处理状态栏发出手势跟随信号
            if ((pulldownPanel.y === 0 && pulldownPanel.visible) || 0 === value)
                return

            window.visible = true
            pulldownPanel.visible = true
            PulldownManager.setVisible(true)
            pulldownPanel.y = -Screen.height + value
            pulldownPanel.imageSource = imagePath
        }
    }
}
