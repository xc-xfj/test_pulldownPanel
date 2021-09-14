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


#ifndef PULLDOWNMANAGER_H
#define PULLDOWNMANAGER_H

#include <QObject>

/**
 * @brief The Manager class 管理dbus服务及信号，与ui进行通信
 */
class PullDownManager : public QObject
{
    Q_OBJECT
public:
    explicit PullDownManager(QObject *parent = nullptr);
    Q_INVOKABLE void setVisible(bool visible);
    Q_INVOKABLE bool isVisible() { return m_isVisible; } // qml调用时函数名需要小写
    Q_INVOKABLE void hide() { Hide(); }
    Q_INVOKABLE int distance() { return m_distance; } // 使用手势唤起下拉面板的有效距离，大于此距离时无法唤起下拉面板
private:
    void initConnections();

public Q_SLOTS:
    void Toggle();
    void Show();
    void Hide();
    bool IsVisible();

Q_SIGNALS:
    /**
     * @brief swipeDown 快速下划手势
     */
    void swipeDown();
    /**
     * @brief swipeUp 快速上划手势
     */
    void swipeUp();
    void toggled();
    /**
     * @brief moveDown 缓慢划动
     * @param value 滑动距离
     */
    void moveDown(int value); // 缓慢划动
    void lockStatusChanged(bool isLock);
    void visibleChanged(bool visible);
    void rotationLockChanged(bool lock);

private:
    bool m_isVisible;                    // 下拉面板是否可见
    int m_distance;
};

#endif // PULLDOWNMANAGER_H
