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
                name: "bla"
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

        ListModel {
            id: numberWeightsModel

            ListElement {
                name: "bla"
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

                    keys: "numberWeightHeader"

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

                        console.log("weightElementDroppedName- "+ className + " " + drag.source.name)

                        numberWeightHeadersModel.setProperty(index, "name", drag.source.name)

                        callUpdateNumberWeightHeaderCaption()

                        console.log(numberWeightHeadersModel.get(index).name)
                    }

                    function callUpdateNumberWeightHeaderCaption() {
                        numberWeightHeaderElement.updateNumberWeightHeaderCaption()
                    }
                }

                DropArea {
                    id: numberWeightsDropArea

                    keys: "numberWeight"

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
                        console.log("dropped number in: " + index)

                        console.log("weightElementDroppedName- "+ className + " " + drag.source.name)

                        numberWeightHeadersModel.setProperty(index, "name", drag.source.name)

                        callUpdateNumberWeightHeaderCaption()

                        console.log(numberWeightHeadersModel.get(index).name)
                    }

                    function callUpdateNumberWeightHeaderCaption() {
                        numberWeightHeaderElement.updateNumberWeightHeaderCaption()
                    }
                }

                Grid {
                    id: numberWeightDropAreas

                    anchors.left: parent.left; anchors.bottom: parent.bottom;
                    width: parent.width
                    height: parent.height

                    opacity: 0.5

                    columns: 3

                    Repeater {
                        model: 9
                        //delegate: DropWeightTile { colorKey: "blue" }
                    }
                }



            }
        }
    }
}

