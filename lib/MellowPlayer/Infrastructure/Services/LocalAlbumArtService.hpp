#pragma once

#include <MellowPlayer/UseCases/Services/ILocalAlbumArtService.hpp>

PREDECLARE_MELLOWPLAYER_CLASS(UseCases, IPlayer)
PREDECLARE_MELLOWPLAYER_CLASS(UseCases, IAlbumArtDownloader)

BEGIN_MELLOWPLAYER_NAMESPACE(Infrastructure)

class LocalAlbumArtService: public UseCases::ILocalAlbumArtService {
    Q_OBJECT
public:
    LocalAlbumArtService(UseCases::IPlayer& player, UseCases::IAlbumArtDownloader& downloader);

    const QString& getUrl() const override;
    bool isSongArtReady(const UseCases::Song& song) override;

private slots:
    void onCurrentSongChanged(UseCases::Song* song);
    void onDownloadFinished(const QString& newUrl);

private:
    UseCases::IAlbumArtDownloader& downloader;
    QString url;
};

END_MELLOWPLAYER_NAMESPACE
