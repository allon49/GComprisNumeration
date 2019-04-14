
/* GCompris - NumberWeightHeaderElement.qml
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
    id: numberWeightHeaderElement
    color: "darkred"
    radius: 0.2
    z: 1

    anchors.top: parent.top

    property int lastX
    property int lastY

    property Item dragParent

    Drag.active: numberWeightHeaderDragArea.drag.active
    Drag.keys: "NumberWeightHeader"

    function updateNumberWeightHeaderCaption() {
        console.log("rrrr " + index )
        numberWeightHeaderCaption.text = numberWeightsModel.get(index).name
    }


    //displays the number of candies each child has
    GCText {
        id: numberWeightHeaderCaption

        anchors.fill: parent
        anchors.bottom: parent.bottom
        fontSizeMode: Text.Fit
        color: "white"
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        text: numberWeightsModel.get(index).name
    }

    MouseArea {
        id: numberWeightHeaderDragArea
        anchors.fill: parent
        drag.target: numberWeightHeaderElement

        onClicked: {             console.log("ggg") }

        onPressed: {
            instruction.hide()
            lastX = numberWeightElement.x
            lastY = numberWeightElement.y


        }

        onReleased: {
        }


        //see with johnny how to oversome this problem
        // see https://stackoverflow.com/questions/32533105/qml-drag-one-component-as-if-it-has-the-top-stacking-order-largest-z
        states: State {
            when: mouseArea.drag.active
            ParentChange { target: numberClassHeaderElement; parent: dragParent }
            AnchorChanges { target: numberClassHeaderElement; anchors.verticalCenter: undefined; anchors.horizontalCenter: undefined }
        }
    }
}
