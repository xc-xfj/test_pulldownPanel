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

#include "pulldownmanager.h"

#include <QGuiApplication>


PullDownManager::PullDownManager(QObject *parent)
    : QObject(parent)
    , m_isVisible(false)
    , m_distance(40)
{
    initConnections();
}

void PullDownManager::initConnections()
{

}

void PullDownManager::Toggle()
{

    Q_EMIT toggled();
}

void PullDownManager::Show()
{

    Q_EMIT swipeDown();
}

void PullDownManager::Hide()
{

    Q_EMIT swipeUp();
}

bool PullDownManager::IsVisible()
{
    return m_isVisible;
}


void PullDownManager::setVisible(bool visible)
{
    if (m_isVisible != visible) {
        m_isVisible = visible;

        Q_EMIT visibleChanged(m_isVisible);
    }
}

