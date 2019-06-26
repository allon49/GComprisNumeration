/* GCompris - Share.qml
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
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQml.Models 2.1

import "../../core"

import "numeration.js" as Activity

ActivityBase {
    id: activity

    onStart: focus = true
    onStop: {}

    pageComponent: Rectangle {
        id: background
        anchors.fill: parent
        color: "#ffffb3"
        signal start
        signal stop

        Component.onCompleted: {
        	dialogActivityConfig.getInitialConfiguration()
            activity.start.connect(start)
            activity.stop.connect(stop)
        }

        // Add here the QML items you need to access in javascript
        QtObject {
            id: items
            property Item main: activity.main
            property alias background: background
            property alias bar: bar
            property alias bonus: bonus
            property alias instruction: instruction
            property int currentSubLevel: 0
            property int nbSubLevel
            property alias listModel: listModel
            property bool acceptCandy: false
            property alias dataset: dataset
           // property alias girlWidget: girlWidget
   //         property alias boyWidget: boyWidget
     //       property alias candyWidget: candyWidget
     //       property alias basketWidget: basketWidget
            property alias leftWidget: leftWidget
            property int totalBoys
            property int totalGirls
            property int totalCandies
            property int totalChildren: totalBoys + totalGirls
            property int barHeightAddon: ApplicationSettings.isBarHidden ? 1 : 3
            property int cellSize: Math.min(background.width / 11, background.height / (9 + barHeightAddon))
       // property alias repeaterDropAreas: repeaterDropAreas
            property int maxNumberOfCandiesPerWidget: 8
        }

        Loader {
            id: dataset
            asynchronous: false
        }

        onStart: { Activity.start(items) }
        onStop: { Activity.stop() }

        property bool vert: background.width >= background.height
        property int currentBoys: 0
        property int currentGirls: 0
        property int currentCandies: 0
        property int rest
        property int placedInGirls
        property int placedInBoys
        property bool showCount: true
        property bool easyMode: true
        property alias wrongMove: wrongMove
        property bool finished: false

        //returns true if the x and y is in the "dest" area
        function contains(x, y, dest) {
            return (x > dest.x && x < dest.x + dest.width &&
                    y > dest.y && y < dest.y + dest.height)
        }

        //stop the candy rotation
        function resetCandy() {
            items.acceptCandy = false;
            candyWidget.element.rotation = 0
        }

        //check if the answer is correct
        function check() {
            background.resetCandy()
            background.finished = true

            var ok = 0
            var okRest = 0

            if (listModel.count >= items.totalChildren) {
                for (var i = 0 ; i < listModel.count ; i++) {
                    if (listModel.get(i).nameS === "basket")
                        okRest = listModel.get(i).countS
                    else if (listModel.get(i).countS === Math.floor(items.totalCandies/items.totalChildren))
                        ok ++
                }

                //condition without rest
                if (rest == 0 && ok == items.totalChildren) {
                    bonus.good("flower")
                    return
                }
                //condition with rest
                else if (rest == okRest && ok == items.totalChildren) {
                    bonus.good("tux")
                    return
                }
            }

            //else => bad
            bonus.bad("flower")
        }


        //mainZone
        DropArea {
            id: mainZoneArea

            width: background.vert ?
                       background.width - leftWidget.width - 40 : background.width - 40
            height: ApplicationSettings.isBarHidden ?
                        background.height : background.vert ?
                            background.height - (bar.height * 1.1) :
                            background.height - (bar.height * 1.1) - leftWidget.height

            anchors {
                top: background.vert ? background.top : leftWidget.bottom
                left: background.vert ? leftWidget.right : parent.left
                leftMargin: 20
            }

            keys: "NumberClassKey"

            Rectangle {
                id: dropRectangle

                anchors.fill: parent
                color: "pink"
            }

            onDropped: {
                numberClassListModel.append({"name": drag.source.name})
                console.log("fffff" + drag.source.name)
            }


            Rectangle {
                id: numberToConvertRectangle

                width: parent.width / 5
                height: parent.height / 10
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                color: "red"
            }


            Rectangle {
                id: numberClassHeaders

                height: 50
                width: parent.width
                anchors.top: numberToConvertRectangle.bottom
                anchors.left: parent.left
                anchors.right: parent.right

                ListView {
                       id: listviewid

                       anchors { fill: parent; margins: 2 }

                       model: visualModel
                       orientation: ListView.Horizontal
                       interactive: false

                       spacing: 4
                       cacheBuffer: 50
                 }
            }

            DelegateModel {
                id: visualModel

                model: numberClassListModel
                delegate: nnumberClassHeaderElement
            }



            NumberClassHeaderElement {
                id: numberClassHeaderElement
            }

            Component {
                id: nnumberClassHeaderElement



                MouseArea {
                    id: dragArea

                    property bool held: false

                    anchors { top: parent.top; bottom: parent.bottom }

                    width: mainZoneArea.width / numberClassListModel.count
                    height: 20

                    //anchors.left: parent.left
                    //height: content.height

                    drag.target: held ? content : undefined
                //    drag.axis: Drag.XAxis

                    onPressAndHold: {
                        console.log("tt333")
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


            Component {
                  id: dragDelegate

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
              }



     /*       RowLayout {
                id: numberClassHeadersGridLayout

                anchors.top: numberToConvertRectangle.bottom
                width: parent.width
                height: parent.height/10
                spacing: 10

                Repeater {
                    id: numberClassHeaderElementRepeater
                    model: numberClassListModel

                    NumberClassHeaderElement {
                        id: numberClassHeaderElement


                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumWidth: 50
                        Layout.preferredWidth: 100
                        //dragParent: dragContainer   //try to see all elements on the top does not work
                    }
                }
            }*/


            RowLayout {
                id: numberClassDropAreasGridLayout

                anchors.top: numberClassHeaders.bottom
                width: parent.width
                height: parent.height - numberClassHeaders.height
                spacing: 10

                Repeater {
                    id: numberClassDropAreaRepeater
                    model: numberClassListModel

                    NumberClassDropArea {
                        id: numberClassDropAreaElement

                        className: name  //name comes from numberClassListModel

                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        Layout.minimumWidth: 50
                        Layout.preferredWidth: 100
                    }
                }
            }
        }


        ListModel {
            id: numberClassListModel
        }


        ListModel {
            id: listModel
        }

        //center zone
/*        Rectangle {
            id: grid
            z: 4

            //map the coordinates from widgets to grid
            property var boy: leftWidget.mapFromItem(boyWidget, boyWidget.element.x, boyWidget.element.y)
            property var girl: leftWidget.mapFromItem(girlWidget, girlWidget.element.x, girlWidget.element.y)
            property var basket: leftWidget.mapFromItem(basketWidget, basketWidget.element.x, basketWidget.element.y)

            //show that the widget can be dropped here
            color: background.contains(boy.x, boy.y, grid) ||
                   background.contains(girl.x, girl.y, grid) ||
                   background.contains(basket.x, basket.y, grid) ? "pink" : "transparent"

            anchors {
                top: background.vert ? parent.top : leftWidget.bottom
                left: background.vert ? leftWidget.right : parent.left
                topMargin: 20
                leftMargin: 20
            }

            width: background.vert ?
                       background.width - leftWidget.width - 40 : background.width - 40
            height: ApplicationSettings.isBarHidden ?
                        background.height : background.vert ?
                            background.height - (bar.height * 1.1) :
                            background.height - (bar.height * 1.1) - leftWidget.height

            //shows/hides the Instruction
            MouseArea {
                anchors.fill: parent
                // first hide the wrong move if visible, then show/hide instruction
                onClicked: wrongMove.visible ? wrongMove.visible = false :
                           (instruction.opacity === 0) ?
                               instruction.show() : instruction.hide()
            }


            ListModel {
                id: numberClassListModel
            }

            RowLayout {
                id: gridlayout

                width: parent.width

                spacing: 10

                Repeater {
                    id: numberClassDroppedElementRepeater2
                    model: listModel

                    NumberClassDroppedElement {
                        id: numberClassDroppedElement22

                        Layout.fillWidth: true
                        Layout.minimumWidth: 50
                        Layout.preferredWidth: 100


                    }
                }


            }



            ListModel {
                id: listModel
            }

            Flow {
                id: dropAreas
                spacing: 10

                width: parent.width
                height: parent.height

                Repeater {
                    id: repeaterDropAreas
                    model: listModel

                    DropChild {
                        id: rect2
                        //"nameS" from listModel
                        name: nameS
                    }
                }
            }
        }*/

        //instruction rectangle
        Rectangle {
            id: instruction
            anchors.fill: instructionTxt
            opacity: 0.8
            radius: 10
            border.width: 2
            z: 10
            border.color: "black"
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#000" }
                GradientStop { position: 0.9; color: "#666" }
                GradientStop { position: 1.0; color: "#AAA" }
            }

            property alias text: instructionTxt.text

            Behavior on opacity { PropertyAnimation { duration: 200 } }

            //shows/hides the Instruction
            MouseArea {
                anchors.fill: parent
                onClicked: instruction.hide()
                enabled: instruction.opacity !== 0
            }

            function show() {
                if(text)
                    opacity = 1
            }
            function hide() {
                opacity = 0
            }
        }

        //instruction for playing the game
        GCText {
            id: instructionTxt
            anchors {
                top: background.vert ? parent.top : leftWidget.bottom
                topMargin: -10
                horizontalCenter: background.horizontalCenter
            }
            opacity: instruction.opacity
            z: instruction.z
            fontSize: background.vert ? regularSize : smallSize
            color: "white"
            style: Text.Outline
            styleColor: "black"
            horizontalAlignment: Text.AlignHCenter
            width: Math.max(Math.min(parent.width * 0.8, text.length * 8), parent.width * 0.3)
            wrapMode: TextEdit.WordWrap
        }

        //left widget, with girl/boy/candy/basket widgets in a grid
        Rectangle {
            id: leftWidget
            width: background.vert ?
                       items.cellSize * 1.74 : background.width
            height: background.vert ?
                        background.height : items.cellSize * 1.74
            color: "#FFFF42"
            border.color: "#FFD85F"
            border.width: 4
            z: 4


            //grid with ok button and images of a boy, a girl, a candy and a basket

            Flickable {
                id: flickableElement

                anchors.fill: parent
                width: background.height
                height: leftWidget.width
                //contentHeight: gridView.height
                contentHeight: gridView.height * 1.5
                contentWidth: leftWidget.width
                boundsBehavior: Flickable.DragAndOvershootBounds

                Grid {
                    id: gridView
                    x: 10
                    y: 10

                    width: parent.width
                    height: background.height



               //
                    //width: background.vert ? leftWidget.width : 3 * bar.height
               //     height: background.vert ? background.height - 2 * bar.height : bar.height
                    spacing: 10
                    columns: background.vert ? 1 : 5

                    //ok button
                    Image {
                        id: okButton
                        source:"qrc:/gcompris/src/core/resource/bar_ok.svg"
                        sourceSize.width: items.cellSize * 1.5
                        fillMode: Image.PreserveAspectFit

                        MouseArea {
                            id: mouseArea
                            anchors.fill: parent
                            enabled: background.finished ? false : true
                            onPressed: okButton.opacity = 0.6
                            onReleased: okButton.opacity = 1
                            onClicked: background.check()
                        }
                    }


                    NumberClassDragElement {
                        id: unitsClassDragElement
                        name: qsTr("Unit Class")
                        color: "black"
                        Drag.keys: "NumberClassKey"
                    }

                    NumberClassDragElement {
                        id: thousandsClassDragElement
                        name: qsTr("Thousand-Class")
                        color: "black"
                        Drag.keys: "NumberClassKey"
                    }

                    NumberClassDragElement {
                        id: millionsClassDragElement
                        name: qsTr("Million Class")
                        color: "black"
                        Drag.keys: "NumberClassKey"
                    }

                    NumberClassDragElement {
                        id: milliardsClassDragElement
                        name: qsTr("Milliard Class")
                        color: "black"
                        Drag.keys: "NumberClassKey"
                    }

                    NumberClassDragElement {
                        id: unitDragElement
                        name: qsTr("Unit")
                   //     caption: qsTr("Unit")
                        color: "darkred"
                        Drag.keys: "numberWeightHeaderKey"
                        disableDragAfterDrag: false
                    }

                    NumberClassDragElement {
                        id: tenDragElement
                        name: qsTr("Ten")
                     //   caption: qsTr("Ten")
                        color: "darkred"
                        Drag.keys: "numberWeightHeaderKey"
                        disableDragAfterDrag: false
                    }

                    NumberClassDragElement {
                        id: hundredDragElement
                        name: qsTr("Hundred")
                     //   caption: qsTr("Hundred")
                        color: "darkred"
                        Drag.keys: "numberWeightHeaderKey"
                        disableDragAfterDrag: false
                    }

                    NumberWeightDragElement {
                        id: unitWeightDragElement
                        name: "unity"
                        total: items.totalGirls
                        current: background.currentGirls
                        placedInChild: background.placedInGirls
                        Drag.keys: "numberWeightKey"
                    }

                    NumberWeightDragElement {
                        id: tenWeightDragElement
                        name: "ten"
                        total: items.totalGirls
                        current: background.currentGirls
                        placedInChild: background.placedInGirls
                        Drag.keys: "numberWeightKey"
                    }

                    NumberWeightDragElement {
                        id: hundredWeightDragElement
                        name: "hundred"
                        total: items.totalGirls
                        current: background.currentGirls
                        placedInChild: background.placedInGirls
                        caption: "1.000.000"
                        Drag.keys: "numberWeightKey"
                    }

                    NumberWeightDragElement {
                        id: thousandWeightDragElement
                        name: "bag"
                        total: items.totalGirls
                        current: background.currentGirls
                        placedInChild: background.placedInGirls
                        caption: "   1000   "
                        Drag.keys: "numberWeightKey"
                    }

                    NumberWeightDragElement {
                        id: thousandWeightDragElement2
                        name: "bag"
                        total: items.totalGirls
                        current: background.currentGirls
                        placedInChild: background.placedInGirls
                        caption: "   1000   "
                        Drag.keys: "numberWeightKey"
                    }

                    NumberWeightDragElement {
                        id: thousandWeightDragElement3
                        name: "bag"
                        total: items.totalGirls
                        current: background.currentGirls
                        placedInChild: background.placedInGirls
                        caption: "   1000   "
                        Drag.keys: "numberWeightKey"
                    }

                    NumberWeightDragElement {
                        id: thousandWeightDragElement4
                        name: "bag"
                        total: items.totalGirls
                        current: background.currentGirls
                        placedInChild: background.placedInGirls
                        caption: "   1000   "
                        Drag.keys: "numberWeightKey"
                    }

                    NumberWeightDragElement {
                        id: thousandWeightDragElement5
                        name: "bag"
                        total: items.totalGirls
                        current: background.currentGirls
                        placedInChild: background.placedInGirls
                        caption: "   1000   "
                        Drag.keys: "numberWeightKey"
                    }
                }

            }


        }

        // show message warning for placing too many candies in one area
        Rectangle {
            id: wrongMove
            z: 5
            color: "orange"
            radius: width / height * 10
            visible: false

            width: grid.width
            height: grid.height / 3
            anchors.centerIn: grid

            MouseArea {
                anchors.fill: parent
                onClicked: parent.visible = false
            }
            GCText {
                id: wrongMoveText
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                width: parent.width - 2 // -2 for margin
                height: parent.height
                fontSizeMode: Text.Fit
                wrapMode: Text.WordWrap
                color: "#404040"
                text: qsTr("You can't put more than %1 pieces of candy in the same rectangle").arg(items.maxNumberOfCandiesPerWidget)
            }
        }

        DialogActivityConfig {
            id: dialogActivityConfig
            currentActivity: activity
            content: Component {
                Item {
                    height: column.height

                    Column {
                        id: column
                        spacing: 10
                        width: parent.width

                        GCDialogCheckBox {
                            id: easyModeBox
                            width: dialogActivityConfig.width
                            text: qsTr("Display candy counter")
                            checked: background.easyMode
                            onCheckedChanged: {
                                background.easyMode = checked
                                Activity.reloadRandom()
                            }
                        }
                    }
                }
            }

            onLoadData: {
                if(dataToSave && dataToSave["mode"]) {
                    background.easyMode = (dataToSave["mode"] === "true");
                }
            }

            onSaveData: {
                dataToSave = { "mode": "" + background.easyMode }
            }

            onClose: home()
        }

        //bar buttons
        DialogHelp {
            id: dialogHelp
            onClose: home()
        }

        Bar {
            id: bar
            content: BarEnumContent { value: help | home | level | reload | config}
            onHelpClicked: {
                displayDialog(dialogHelp)
            }
            onPreviousLevelClicked: Activity.previousLevel()
            onNextLevelClicked: Activity.nextLevel()
            onHomeClicked: activity.home()
            onReloadClicked: Activity.reloadRandom()
            onConfigClicked: {
                dialogActivityConfig.active = true
                displayDialog(dialogActivityConfig)
            }
        }

        Bonus {
            id: bonus
            Component.onCompleted: {
                win.connect(Activity.nextSubLevel)
            }
            onStop: background.finished = false
        }

        Score {
            anchors {
                left: undefined
                right: leftWidget.right
                bottom: background.vert ? bar.top : leftWidget.bottom
                margins: 3 * ApplicationInfo.ratio
            }
            width: basketWidget.width
            height: background.vert ? (basketWidget.height * 0.8) : basketWidget.height
            numberOfSubLevels: items.nbSubLevel
            currentSubLevel: items.currentSubLevel + 1
        }
    }

    Item {
        id: dragContainer
        anchors.fill: parent
    }

}
