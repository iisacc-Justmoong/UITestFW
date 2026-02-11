import QtQuick
import LVRS 1.0 as UIF

UIF.ApplicationWindow {
    id: root

    visible: true
    width: 920
    height: 760
    title: "Typing Practice"
    subtitle: "LVRS Example"
    navigationEnabled: false

    readonly property var practiceTexts: [
        "Framework design drives implementation quality.",
        "Predictable APIs reduce integration risk.",
        "Measure latency, then optimize the critical path.",
        "Small iterative improvements compound over time.",
        "Readable code is cheaper to maintain."
    ]

    property int textIndex: 0
    property string targetText: String(practiceTexts[textIndex])
    property string typedText: ""
    property bool running: false
    property bool roundFinished: false
    property int elapsedSeconds: 0
    property int completedRounds: 0
    property string statusMessage: "시작을 누르면 타자 연습이 시작된다."

    readonly property int targetLength: targetText.length
    readonly property int typedLength: typedText.length
    readonly property int comparedLength: Math.min(typedLength, targetLength)
    readonly property int correctChars: calculateCorrectChars()
    readonly property int wrongChars: comparedLength - correctChars
    readonly property real progressChars: Math.min(typedLength, targetLength)
    readonly property real progressPercent: targetLength > 0 ? (progressChars / targetLength) * 100.0 : 0
    readonly property real accuracy: typedLength > 0 ? (correctChars / typedLength) * 100.0 : 100.0
    readonly property real elapsedMinutes: elapsedSeconds > 0 ? elapsedSeconds / 60.0 : 0.0
    readonly property real wpm: elapsedMinutes > 0 ? (correctChars / 5.0) / elapsedMinutes : 0.0
    readonly property real cpm: elapsedMinutes > 0 ? typedLength / elapsedMinutes : 0.0

    Timer {
        id: sessionTimer
        interval: 1000
        repeat: true
        running: root.running
        onTriggered: root.elapsedSeconds += 1
    }

    function roundValue(value) {
        return Math.round(value * 10) / 10
    }

    function calculateCorrectChars() {
        const max = Math.min(typedText.length, targetText.length)
        let correct = 0
        for (let i = 0; i < max; i++) {
            if (typedText.charAt(i) === targetText.charAt(i))
                correct += 1
        }
        return correct
    }

    function evaluateInput(text) {
        typedText = text
        if (!running || roundFinished)
            return

        if (typedText === targetText)
            finishRound()
    }

    function startRound() {
        running = true
        roundFinished = false
        elapsedSeconds = 0
        typedText = ""
        typingInput.text = ""
        statusMessage = "연습 중이다. 문장을 정확히 입력하면 완료된다."
        typingInput.forceInputFocus()
    }

    function finishRound() {
        running = false
        roundFinished = true
        completedRounds += 1
        statusMessage = "완료: 정확도 " + roundValue(accuracy) + "%, WPM " + roundValue(wpm)
    }

    function resetRound() {
        running = false
        roundFinished = false
        elapsedSeconds = 0
        typedText = ""
        typingInput.text = ""
        statusMessage = "초기화 완료. 시작을 눌러 다시 진행한다."
    }

    function nextText() {
        textIndex = (textIndex + 1) % practiceTexts.length
        targetText = String(practiceTexts[textIndex])
        resetRound()
        statusMessage = "새 문장으로 변경되었다."
    }

    Flickable {
        id: scrollArea
        anchors.fill: parent
        anchors.margins: UIF.Theme.gap24
        clip: true
        contentWidth: width
        contentHeight: contentColumn.implicitHeight

        Column {
            id: contentColumn
            width: scrollArea.width
            spacing: UIF.Theme.gap12

            UIF.AppCard {
                id: targetCard
                width: parent.width
                title: "Target Sentence"
                subtitle: "문장을 정확히 입력한다"

                Column {
                    width: targetCard.width - (targetCard.cardPadding * 2)
                    spacing: UIF.Theme.gap10

                    UIF.Label {
                        width: parent.width
                        style: body
                        wrapMode: Text.WordWrap
                        text: root.targetText
                    }

                    UIF.ProgressBar {
                        width: parent.width
                        size: regular
                        startValue: 0
                        endValue: root.targetLength
                        currentValue: root.progressChars
                    }

                    UIF.Label {
                        width: parent.width
                        style: caption
                        text: "진행: " + root.progressChars + " / " + root.targetLength
                    }
                }
            }

            UIF.AppCard {
                id: inputCard
                width: parent.width
                title: "Typing Input"
                subtitle: "실제 입력 영역"

                Column {
                    width: inputCard.width - (inputCard.cardPadding * 2)
                    spacing: UIF.Theme.gap10

                    UIF.InputField {
                        id: typingInput
                        width: parent.width
                        enabled: root.running && !root.roundFinished
                        placeholderText: "Start를 누르면 입력 가능하다"
                        onTextEdited: root.evaluateInput(text)
                        onAccepted: root.evaluateInput(text)
                    }

                    Row {
                        spacing: UIF.Theme.gap8

                        UIF.LabelButton {
                            text: root.running ? "Running" : "Start"
                            tone: UIF.AbstractButton.Accent
                            enabled: !root.running
                            onClicked: root.startRound()
                        }

                        UIF.LabelButton {
                            text: "Reset"
                            tone: UIF.AbstractButton.Default
                            enabled: !root.running
                            onClicked: root.resetRound()
                        }

                        UIF.LabelButton {
                            text: "Next Text"
                            tone: UIF.AbstractButton.Default
                            enabled: !root.running
                            onClicked: root.nextText()
                        }
                    }

                    UIF.Label {
                        width: parent.width
                        style: description
                        wrapMode: Text.WordWrap
                        text: root.statusMessage
                    }
                }
            }

            UIF.AppCard {
                id: metricsCard
                width: parent.width
                title: "Metrics"
                subtitle: "정확도와 속도 지표"

                Column {
                    width: metricsCard.width - (metricsCard.cardPadding * 2)
                    spacing: UIF.Theme.gap8

                    Row {
                        spacing: UIF.Theme.gap8
                        UIF.Label { style: body; text: "Elapsed: " + root.elapsedSeconds + "s" }
                        UIF.Label { style: body; text: "Rounds: " + root.completedRounds }
                    }

                    Row {
                        spacing: UIF.Theme.gap8
                        UIF.Label { style: body; text: "Correct: " + root.correctChars }
                        UIF.Label { style: body; text: "Wrong: " + root.wrongChars }
                    }

                    Row {
                        spacing: UIF.Theme.gap8
                        UIF.Label { style: body; text: "Accuracy: " + root.roundValue(root.accuracy) + "%" }
                        UIF.Label { style: body; text: "WPM: " + root.roundValue(root.wpm) }
                        UIF.Label { style: body; text: "CPM: " + root.roundValue(root.cpm) }
                    }

                    UIF.Label {
                        width: parent.width
                        style: caption
                        wrapMode: Text.WordWrap
                        text: "입력 길이: " + root.typedLength + " / " + root.targetLength
                    }
                }
            }
        }
    }
}
