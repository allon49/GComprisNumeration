/* GCompris - NumberClassDropArea.qml
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

import "../../core"


Rectangle {
    id: numberClassDropArea

    property string className
    property var unitColumnWeightImagesArray: ["","","","","","","","",""]
    property int unitColumnWeightImagesArrayIndex: 0
    property var tenColumnWeightImagesArray: ["","","","","","","","",""]
    property int tenColumnWeightImagesArrayIndex: 0
    property var hundredColumnWeightImagesArray: ["","","","","","","","",""]
    property int hundredColumnWeightImagesArrayIndex: 0


    width: parent.width
    height: parent.height - numberClassHeadersGridLayout.height

    color: "blue"


    RowLayout {
        id: numberWeightsDropAreasRowLayout

     //   anchors.top: numberClassHeadersGridLayout.bottom
        width: parent.width
        height: parent.height
        spacing: 10

        ListModel {
            id: numberWeightHeadersModel

            ListElement {
                name: "?"
                weightElementDroppedName: ""
            }
            ListElement {
                name: "?"
                weightElementDroppedName: ""
            }
            ListElement {
                name: "?"
                weightElementDroppedName: ""
            }
        }


        Repeater {
            id: numberWeightsDropAreasRepeater
            model: numberWeightHeadersModel

            Rectangle {
                id: numberWeightDropAreaRectangle

                property var lastColor

                color: "lightsteelblue"
                z: 100000

                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.minimumWidth: 50
                Layout.preferredWidth: 100

                NumberWeightHeaderElement {
                    id: numberWeightHeaderElement

                    x: 0 //numberWeightDropAreaRectangle.x
                    y: 0 //numberWeightDropAreaRectangle.y
                    width: numberWeightDropAreaRectangle.width
                    height: numberWeightDropAreaRectangle.height /10

                }


                DropArea {
                    id: numberWeightsHeaderDropArea

                    keys: "numberWeightHeaderKey"

                    anchors.top: numberWeightHeaderElement.bottom
                    width: parent.width
                    height: parent.height - numberWeightHeaderElement.height

                    states: [
                       State {
                           when: numberWeightsHeaderDropArea.containsDrag
                           PropertyChanges {
                               target: numberWeightDropAreaRectangle
                               color: "grey"
                           }
                       }
                    ]

                    onDropped: {
                        //console.log("dropped number in: " + numberWeightHeadersModel.get(index).name)
                        console.log("dropped number in: " + index)

                        console.log("Header- "+ className + " " + drag.source.name)

                        numberWeightHeadersModel.setProperty(index, "name", drag.source.name)

                        callUpdateNumberWeightHeaderCaption()

                        console.log(numberWeightHeadersModel.get(index).name)
                    }

                    function callUpdateNumberWeightHeaderCaption() {
                        numberWeightHeaderElement.updateNumberWeightHeaderCaption()
                    }
                }


                Rectangle {
                    id: numberWeightsDropTiles

                    anchors.top: numberWeightHeaderElement.bottom
                    width: parent.width
                    height: parent.height - numberWeightHeaderElement.height
                    z:1

                    Grid {
                        id: numberWeightDropAreaGrid

                        anchors.left: parent.left
                        anchors.top: numberWeightHeaderElement.bottom;
                        anchors.bottom: parent.bottom;
                        width: parent.width
                        height: parent.height

                        opacity: 0.5

                        columns: 3

                        Repeater {
                            id: numberWeightDropAreaGridRepeater
                            model: 9


                            DropArea {

                                keys: "numberWeightKey"

                                width: parent.width/3
                                height: parent.height/3

                                onDropped: {
                                    console.log("dropped number in: " + index)

                                    numberWeightImageTile.source = "qrc:/gcompris/src/activities/numeration/resource/images/" + drag.source.name + ".svg"


                                }

                                Rectangle {
                                    id: numberWeightRectangleTile

                                    property string src

                                    //color: "red"
                                    border.color: "black"
                                    border.width: 5
                                    radius: 10
                                    width: parent.width
                                    height: parent.height

                                    color: "green"

                                    Image {
                                        id: numberWeightImageTile

                                        anchors.horizontalCenter: parent.anchors.horizontalCenter    //anchor does not work like I thought it would
                                        anchors.verticalCenter: parent.anchors.verticalCenter
                                        source: numberWeightRectangleTile.src

                                        sourceSize.width: parent.width
                                        sourceSize.height: parent.height
                                        z: 100

                                        MouseArea {
                                             anchors.fill: parent
                                             onClicked: {
                                                 console.log("ttttttttttttttttttttttt")
                                                 numberWeightImageTile.source = ""

                                             }
                                         }
                                    }
                                }
                            }
                        }
                    }
                }




        /*        DropArea {
                    id: numberWeightsDropArea

                    keys: "numberWeightKey"

                    anchors.top: numberWeightHeaderElement.bottom
                    width: parent.width
                    height: parent.height - numberWeightHeaderElement.height

                    states: [
                       State {
                           when: numberWeightsDropArea.containsDrag
                           PropertyChanges {
                               target: numberWeightDropAreaRectangle
                               color: "green"
                           }
                       }
                    ]

                    onDropped: {

                        console.log("dropped number in: " + index)

                        if (index == 0) {
                            if (hundredColumnWeightImagesArrayIndex < 9) {
                                hundredColumnWeightImagesArray[hundredColumnWeightImagesArrayIndex] = "qrc:/gcompris/src/activities/numeration/resource/images/" + drag.source.name + ".svg"
                                hundredColumnWeightImagesArrayIndex++
                                console.log("debug numberWeightsUnitColumnModelRepeater: " + unitColumnWeightImagesArray[0])
                            }

                            console.log("debug montre noms des images:")
                            for (var i=0; i<hundredColumnWeightImagesArray.length;i++) {
                                numberWeightDropAreaGridRepeater.itemAt(i).src = hundredColumnWeightImagesArray[i]
                                console.log(hundredColumnWeightImagesArray[i])
                            }
                        }

                        if (index == 1) {
                            if (tenColumnWeightImagesArrayIndex < 9) {
                                tenColumnWeightImagesArray[tenColumnWeightImagesArrayIndex] = "qrc:/gcompris/src/activities/numeration/resource/images/" + drag.source.name + ".svg"
                                tenColumnWeightImagesArrayIndex++
                                console.log("debug numberWeightsUnitColumnModelRepeater: " + unitColumnWeightImagesArray[0])
                            }

                            console.log("debug montre noms des images:")
                            for (var j=0; j<tenColumnWeightImagesArray.length;j++) {
                                numberWeightDropAreaGridRepeater.itemAt(j).src = tenColumnWeightImagesArray[j]
                                console.log(tenColumnWeightImagesArray[j])
                            }
                        }

                        if (index == 2) {
                            if (unitColumnWeightImagesArrayIndex < 9) {
                                unitColumnWeightImagesArray[unitColumnWeightImagesArrayIndex] = "qrc:/gcompris/src/activities/numeration/resource/images/" + drag.source.name + ".svg"
                                unitColumnWeightImagesArrayIndex++
                                console.log("debug numberWeightsUnitColumnModelRepeater: " + unitColumnWeightImagesArray[0])
                            }

                            console.log("debug montre noms des images:")
                            for (var k=0; k<unitColumnWeightImagesArray.length;k++) {
                                numberWeightDropAreaGridRepeater.itemAt(k).src = unitColumnWeightImagesArray[k]
                                console.log(unitColumnWeightImagesArray[k])
                            }
                        }









                  /*      //apppend or remove a var and update the Repeater accordingly

                        numberWeightDropAreaGridRepeater.itemAt(1).src = "qrc:/gcompris/src/activities/numeration/resource/images/unity.svg"
                        //numberWeightDropAreaGridRepeater.itemAt(0).numberWeightDropAreaImage.x

                        callUpdateNumberWeightElements()

                        console.log(numberWeightHeadersModel.get(index).name)*/



/*                    }

                    function callUpdateNumberWeightElements() {
                        numberWeightHeaderElement.updateNumberWeightHeaderCaption()
                    }
                }*/


            /*    GridLayout {
                    id: grid
                    columns: 3

                    Text { text: "Three"; font.bold: true; }
                    Text { text: "words"; color: "red" }
                    Text { text: "in"; font.underline: true }
                    Text { text: "a"; font.pixelSize: 20 }
                    Text { text: "row"; font.strikeout: true }
                }*/


     /*           Grid {
                    id: numberWeightDropAreaGrid

                    anchors.left: parent.left
                    anchors.top: numberWeightHeaderElement.bottom;
                    anchors.bottom: parent.bottom;
                    width: parent.width
                  //  height: parent.height

                    opacity: 0.5

                    columns: 3

                    Repeater {
                        id: numberWeightDropAreaGridRepeater
                        model: 9



                        Rectangle {
                            id: numberWeightRectangleTile

                            property string src

                            //color: "red"
                            border.color: "black"
                            border.width: 5
                            radius: 10
                            width: parent.width/3
                            height: parent.height/3
                            z: 1


                            Image {
                                id: numberWeightImageTile
                                source: numberWeightRectangleTile.src

                                sourceSize.width: parent.width
                                sourceSize.height: parent.height
                                z: 100

                                MouseArea {
                                     anchors.fill: parent
                                     onClicked: {
                                         console.log("ttttttttttttttttttttttt")
                                     }
                                 }
                            }
                        }
                    }
                }*/
            }
        }
    }
}

