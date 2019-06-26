 
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

/*Component {
      id: numberClassHeaderElement

      Rectangle {
          id: content

          width: mainZoneArea.width / numberClassListModel.count

        //  anchors { left: parent.left; right: parent.right }
          height: column.implicitHeight + 4

          border.width: 1
          border.color: "lightsteelblue"

          radius: 2

          Column {
              id: column
              anchors { fill: parent; margins: 2 }

              Text { text: 'Name: ' + name }
              Text { text: 'Type: ' + type }
              Text { text: 'Age: ' + age }
              Text { text: 'Size: ' + size }
          }
      }
  }*/




Component {
    id: numberClassHeaderElement



    MouseArea {
        id: dragArea

        property bool held: false

//        anchors { left: parent.left; right: parent.right }

        width: mainZoneArea.width / numberClassListModel.count
        height: 20

        //anchors.left: parent.left
        //height: content.height

        drag.target: held ? content : undefined
        drag.axis: Drag.XAxis

        onPressed: {
            console.log("tt")
            held = true
        }
        onReleased: held = false

        Rectangle {
            id: content

            anchors {
                horizontalCenter: parent.horizontalCenter
                verticalCenter: parent.verticalCenter
            }
            width: dragArea.width;

            height: 20 //à fixer



            border.width: 1
            border.color: "lightsteelblue"

            color: dragArea.held ? "lightsteelblue" : "white"
            Behavior on color { ColorAnimation { duration: 100 } }

            radius: 2

            Drag.active: dragArea.held
            Drag.source: dragArea
            Drag.hotSpot.x: width / 2
            Drag.hotSpot.y: height / 2

            states: State {
                when: dragArea.held

                ParentChange { target: content; parent: root }
                AnchorChanges {
                    target: content
                    anchors { horizontalCenter: undefined; verticalCenter: undefined }
                }
            }

            GCText {
                id: numberClassHeaderCaption

                anchors.fill: parent
                anchors.bottom: parent.bottom
                fontSizeMode: Text.Fit
                color: "black"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                text: numberClassListModel.get(index).name
                z: 100
            }

        }

        DropArea {
            anchors { fill: parent; margins: 10 }

            onEntered: {

                console.log("entered")
                visualModel.items.move(
                        drag.source.DelegateModel.itemsIndex,
                        dragArea.DelegateModel.itemsIndex)
                        console.log("drag.source.DelegateModel.itemsIndex : " + drag.source.DelegateModel.itemsIndex)
                        console.log("dragArea.DelegateModel.itemsIndex : " + dragArea.DelegateModel.itemsIndex)
            }
        }
    }
}

/*
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
                console.log("-----numberClassHeaderElement.x > numberClassHeaderElementRepeater.itemAt(i).x && numberClassHeaderElement.x < numberClassHeaderElementRepeater.itemAt(i+1).x)")
console.log( numberClassHeaderElement.x + " >= " + numberClassHeaderElementRepeater.itemAt(i).x + " && " + numberClassHeaderElement.x + " <=a  " + numberClassHeaderElementRepeater.itemAt(i+1).x)
            if (numberClassHeaderElement.x >= numberClassHeaderElementRepeater.itemAt(i).x && numberClassHeaderElement.x <= numberClassHeaderElementRepeater.itemAt(i+1).x) {


              if (i === index) {
                numberClassHeaderElement.x = numberClassHeaderElement.lastX
                numberClassHeaderElement.y = numberClassHeaderElement.lastY
                console.log("tyklkldkjflkjglkdjflkgj")
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
*/
