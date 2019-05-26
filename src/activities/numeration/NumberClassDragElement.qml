/* GCompris - NumberClassDragElement.qml
 *
 * Copyright (C) 2016 Stefan Toncu <stefan.toncu29@gmail.com>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program; if not, see <https://www.gnu.org/licenses/>.
 */

import QtQuick 2.6
import GCompris 1.0

import "../../core"

Rectangle {
    id: numberClassDragElement

    width: parent.width - parent.width/5
    height: parent.height / 15
    z: 1000

    //initial position of the element
    //(these vars are assigned to element after release of click mouse)
    property int lastX
    property int lastY
    property int lastZ
    property string src
    property int current: 0
    property int total: 0
    property string name
    property bool canDrag: true
    property string availableItems
    property bool disableDragAfterDrag: true

    Drag.active: numberClassDragElementMouseArea.drag.active

    //number of available items
    GCText {
        id: numberClassElementCaption

        anchors.fill: parent
        anchors.bottom: parent.bottom
        fontSizeMode: Text.Fit
        color: "white"
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        text: name
    }


    MouseArea {
        id: numberClassDragElementMouseArea
        anchors.fill: parent

        drag.target: (numberClassDragElement.canDrag) ? parent : null
        drag.axis: numberClassDragElement.x < parent.width ? Drag.XAxis : Drag.XAndYAxis
        onPressed: {
            instruction.hide()
            //set the initial position
            numberClassDragElement.lastX = numberClassDragElement.x
            numberClassDragElement.lastY = numberClassDragElement.y
            numberClassDragElement.lastZ = numberClassDragElement.z
            numberClassDragElement.z = 100000
            console.log("moving left element")
        }

        onReleased: {
            parent.Drag.drop()
            //set the element to its initial coordinates
            numberClassDragElement.x = numberClassDragElement.lastX
            numberClassDragElement.y = numberClassDragElement.lastY

            numberClassDragElement.opacity = disableDragAfterDrag ? 0.5 : 1
            numberClassDragElement.canDrag = !disableDragAfterDrag
            numberClassDragElement.z = numberClassDragElement.lastZ
        }
    }
}
