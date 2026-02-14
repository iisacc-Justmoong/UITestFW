#include <QtTest>

#include <QCoreApplication>
#include <QKeyEvent>
#include <QScopedPointer>
#include <QQmlEngine>
#include <QtPlugin>

#include "test_utils.h"

Q_IMPORT_PLUGIN(LVRSPlugin)

class TextEditorTests : public QObject
{
    Q_OBJECT

private slots:
    void text_editor_default_contract_and_utility_api();
    void text_editor_mode_independent_render_contract_and_submit_signal();
};

void TextEditorTests::text_editor_default_contract_and_utility_api()
{
    QQmlEngine engine;
    engine.addImportPath(TestUtils::qmlImportBase());

    const QByteArray qml = R"(
import QtQuick
import LVRS as LV

Item {
    id: root
    width: 640
    height: 360

    property bool defaultModeReady: editor.mode === editor.plainTextMode
        && editor.effectiveWrapMode === TextEdit.Wrap
        && editor.effectiveTextFormat === TextEdit.PlainText
        && editor.enforceModeDefaults
        && editor.backgroundColorFocused === editor.backgroundColor
        && editor.backgroundColorDisabled === editor.backgroundColor
    property bool bodyTokenReady: editor.fontPixelSize === LV.Theme.textBody
        && editor.fontWeight === LV.Theme.textBodyWeight
        && editor.textLineHeight === LV.Theme.textBodyLineHeight

    LV.TextEditor {
        id: editor
        objectName: "textEditor"
        width: 420
        height: 220
        placeholderText: "Write here"
    }
}
)";

    QScopedPointer<QObject> root(TestUtils::createFromQml(engine, qml));
    QVERIFY(root);
    QVERIFY(root->property("defaultModeReady").toBool());
    QVERIFY(root->property("bodyTokenReady").toBool());

    QObject *editor = root->findChild<QObject *>(QStringLiteral("textEditor"));
    QVERIFY(editor);
    QVERIFY(editor->property("empty").toBool());
    QVERIFY(editor->property("enforceModeDefaults").toBool());

    QVERIFY(QMetaObject::invokeMethod(editor, "insertText", Q_ARG(QVariant, QVariant(QStringLiteral("hello")))));
    QCOMPARE(editor->property("text").toString(), QStringLiteral("hello"));
    QVERIFY(!editor->property("empty").toBool());
    QCOMPARE(editor->property("normalizedInput").toString(), QStringLiteral("hello"));
    QCOMPARE(editor->property("renderedPlainText").toString(), QStringLiteral("hello"));
    QCOMPARE(editor->property("renderedOutput").toString(), QStringLiteral("hello"));

    QVERIFY(QMetaObject::invokeMethod(editor, "clear"));
    QCOMPARE(editor->property("text").toString(), QString());
    QVERIFY(editor->property("empty").toBool());
}

void TextEditorTests::text_editor_mode_independent_render_contract_and_submit_signal()
{
    QQmlEngine engine;
    engine.addImportPath(TestUtils::qmlImportBase());

    const QByteArray qml = R"(
import QtQuick
import LVRS as LV

LV.ApplicationWindow {
    id: root
    width: 640
    height: 420
    visible: false
    desktopMinWidth: 0
    desktopMinHeight: 0
    mobileMinWidth: 0
    mobileMinHeight: 0

    property int submitCount: 0
    property bool markdownModeReady: editor.mode === editor.markdownMode
        && editor.effectiveWrapMode === TextEdit.Wrap
        && editor.effectiveTextFormat === TextEdit.PlainText
    property bool richModeReady: editor.mode === editor.richTextMode
        && editor.effectiveWrapMode === TextEdit.Wrap
        && editor.effectiveTextFormat === TextEdit.PlainText

    LV.TextEditor {
        id: editor
        objectName: "textEditor"
        anchors.fill: parent
        text: "Hello **bold**"
        onSubmitted: root.submitCount += 1
    }

    function setPlainMode() { editor.mode = editor.plainTextMode }
    function setMarkdownMode() { editor.mode = editor.markdownMode }
    function setRichMode() { editor.mode = editor.richTextMode }
}
)";

    QScopedPointer<QObject> root(TestUtils::createFromQml(engine, qml));
    QVERIFY(root);

    QObject *editor = root->findChild<QObject *>(QStringLiteral("textEditor"));
    QVERIFY(editor);
    QObject *textEdit = root->findChild<QObject *>(QStringLiteral("editorTextEdit"));
    QVERIFY(textEdit);

    const QString plainRendered = editor->property("renderedOutput").toString();
    const QString plainNormalized = editor->property("normalizedInput").toString();

    QVERIFY(QMetaObject::invokeMethod(root.data(), "setMarkdownMode"));
    QVERIFY(root->property("markdownModeReady").toBool());
    QCOMPARE(editor->property("renderedOutput").toString(), plainRendered);
    QCOMPARE(editor->property("normalizedInput").toString(), plainNormalized);

    QVERIFY(QMetaObject::invokeMethod(root.data(), "setRichMode"));
    QVERIFY(root->property("richModeReady").toBool());
    QCOMPARE(editor->property("renderedOutput").toString(), plainRendered);
    QCOMPARE(editor->property("normalizedInput").toString(), plainNormalized);

    editor->setProperty("text", QStringLiteral("<strong>Hello</strong> **bold**"));
    const QString htmlMixedRendered = editor->property("renderedOutput").toString();
    const QString htmlMixedNormalized = editor->property("normalizedInput").toString();

    QVERIFY(QMetaObject::invokeMethod(root.data(), "setPlainMode"));
    QCOMPARE(editor->property("renderedOutput").toString(), htmlMixedRendered);
    QCOMPARE(editor->property("normalizedInput").toString(), htmlMixedNormalized);

    QVERIFY(QMetaObject::invokeMethod(editor, "forceEditorFocus"));
    QKeyEvent submitEvent(QEvent::KeyPress, Qt::Key_Return, Qt::ControlModifier, QStringLiteral("\n"));
    QCoreApplication::sendEvent(textEdit, &submitEvent);
    QTRY_COMPARE(root->property("submitCount").toInt(), 1);
}

QTEST_MAIN(TextEditorTests)
#include "tst_text_editor.moc"
