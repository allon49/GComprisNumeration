 
/* GCompris - NumberClassHeaderElement.qml
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
    id: numberClassHeaderElement
    color: "black"
    radius: 0.2
    z: 1

    property int lastX
    property int lastY

    property Item dragParent

    Drag.active: numberClassHeaderDragArea.drag.active


    //displays the number of candies each child has
    GCText {
        id: numberClassHeaderCaption

        anchors.fill: parent
        anchors.bottom: parent.bottom
        fontSizeMode: Text.Fit
        color: "white"
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        text: numberClassListModel.get(index).name
    }

    MouseArea {
        id: numberClassHeaderDragArea
        anchors.fill: parent
        drag.target: numberClassHeaderElement

        onClicked: {             console.log("ggg") }

        onPressed: {
            instruction.hide()
            lastX = numberClassHeaderElement.x
            lastY = numberClassHeaderElement.y
        }
        onReleased: {
            orderNumberClasses()
        }


        //see with johnny how to oversome this problem
        // see https://stackoverflow.com/questions/32533105/qml-drag-one-component-as-if-it-has-the-top-stacking-order-largest-z
        states: State {
            when: mouseArea.drag.active
            ParentChange { target: numberClassHeaderElement; parent: dragParent }
            AnchorChanges { target: numberClassHeaderElement; anchors.verticalCenter: undefined; anchors.horizontalCenter: undefined }
        }

    }

    function orderNumberClasses() {
        console.log("index: " + index + " numberClassHeaderElement.x: " + numberClassHeaderElement.x + " numberClassHeaderElementRepeater.itemAt(index).x: " + numberClassHeaderElementRepeater.itemAt(index).x + "numberClassHeaderElementRepeater.itemAt(0).x : " + numberClassHeaderElementRepeater.itemAt(0).x)
        if (numberClassHeaderElement.x < numberClassHeaderElementRepeater.itemAt(0).x) {
            if (index == 0) {
                numberClassHeaderElement.x = numberClassHeaderElement.lastX
                numberClassHeaderElement.y = numberClassHeaderElement.lastY
            } else
            {
                numberClassListModel.move(index, 0, 1)
            }
        }
        if (numberClassHeaderElement.x > numberClassHeaderElementRepeater.itemAt(numberClassHeaderElementRepeater.count-1).x) {
            if (index == numberClassHeaderElementRepeater.count-1) {
                numberClassHeaderElement.x = numberClassHeaderElement.lastX
                numberClassHeaderElement.y = numberClassHeaderElement.lastY
            } else
            {
                numberClassListModel.move(index, numberClassHeaderElementRepeater.count-1, 1)
            }
        }
        for (var i = 0; i < numberClassHeaderElementRepeater.count-1; i++) {
          if (numberClassHeaderElement.x > numberClassHeaderElementRepeater.itemAt(i).x && numberClassHeaderElement.x < numberClassHeaderElementRepeater.itemAt(i+1).x) {
            if (i == index) {
                numberClassHeaderElement.x = numberClassHeaderElement.lastX
                numberClassHeaderElement.y = numberClassHeaderElement.lastY
            }
            else
            {
                numberClassListModel.move(index, i, 1)
                console.log("attentin i: " + i)
            }
          }
        }
    }
}

