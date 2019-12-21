#include <MellowPlayer/Presentation/ViewModels/ClipBoardViewModel.hpp>
#include <QApplication>
#include <QClipboard>

using namespace MellowPlayer::Presentation;

ClipBoardViewModel::ClipBoardViewModel(std::shared_ptr<IContextProperties> contextProperties) : ContextProperty("clipboard", this, contextProperties)
{
}

void ClipBoardViewModel::setText(const QString& text)
{
    qApp->clipboard()->setText(text);
    emit textCopied(text);
}

bool ClipBoardViewModel::canPaste() const
{
    return !qApp->clipboard()->text().isEmpty();
}
