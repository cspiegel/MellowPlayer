//---------------------------------------------------------
//
// This file is part of MellowPlayer.
//
// MellowPlayer is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// MellowPlayer is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with MellowPlayer.  If not, see <http://www.gnu.org/licenses/>.
//
//---------------------------------------------------------

#include <QtCore>
#include <mellowplayer.h>

/*!
 * \brief The GroovesharkPlugin class provides integration for the grooveshark
 * music streaming service.
 *
 * The plugin uses the grooveshark's javascript API to interact to implement
 * the IStreamingService interface.
 */
class GroovesharkPlugin :
        public QObject,
        public IStreamingServiceIntegration
{
    Q_OBJECT

#if QT_VERSION >= 0x050000
    Q_PLUGIN_METADATA(IID IStreamingServiceIntegration_iid
                      FILE "grooveshark.json")
#endif
    Q_INTERFACES(IStreamingServiceIntegration)

public:
    GroovesharkPlugin();
    virtual const PluginMetaData& metaData() const;

    //! Returns the grooveshark URL
    virtual QUrl url() const;
    //! Plays the current song
    void play();
    //! Pauses the current song
    void pause();
    //! Stops the current song
    void stop();
    //! Skips to the next song
    void next();
    //! Skips to the previous song
    void previous();
    //! Seeks to the indicated position
    void seekToPosition(int position);
    //! Gets the current song info
    SongInfo currentSongInfo();
    float volume();
    void setVolume(float volume);
};
