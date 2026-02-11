#include <QtTest>

#include <QtPlugin>

#include "backend/text/textmarkup.h"

Q_IMPORT_PLUGIN(LVRSPlugin)

class TextMarkupTests : public QObject
{
    Q_OBJECT

private slots:
    void normalize_converts_html_markup_to_canonical_text();
    void render_html_is_equivalent_for_markdown_and_html_inputs();
    void render_plain_text_returns_normalized_text();
};

void TextMarkupTests::normalize_converts_html_markup_to_canonical_text()
{
    TextMarkup markup;

    const QString input = QStringLiteral("<p>Hello <strong>bold</strong></p><p><em>world</em><br/>`x`</p>");
    const QString normalized = markup.normalize(input);

    QCOMPARE(normalized, QStringLiteral("\nHello **bold**\n\n*world*\n`x`\n"));
}

void TextMarkupTests::render_html_is_equivalent_for_markdown_and_html_inputs()
{
    TextMarkup markup;

    const QString markdownInput = QStringLiteral("Hello **bold** and *accent* with `code`");
    const QString richInput = QStringLiteral("Hello <strong>bold</strong> and <em>accent</em> with <code>code</code>");

    QCOMPARE(markup.renderHtml(markdownInput), markup.renderHtml(richInput));
}

void TextMarkupTests::render_plain_text_returns_normalized_text()
{
    TextMarkup markup;

    const QString input = QStringLiteral("A\r\nB<br/>C");
    QCOMPARE(markup.renderPlainText(input), markup.normalize(input));
    QCOMPARE(markup.renderPlainText(input), QStringLiteral("A\nB\nC"));
}

QTEST_MAIN(TextMarkupTests)
#include "tst_text_markup.moc"
