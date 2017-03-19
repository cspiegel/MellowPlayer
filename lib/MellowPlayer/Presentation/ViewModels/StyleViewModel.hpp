#pragma once

#include <MellowPlayer/UseCases.hpp>

BEGIN_MELLOWPLAYER_NAMESPACE(Presentation)

class StyleViewModel: public QObject {
    Q_OBJECT
    Q_PROPERTY(QString theme READ getTheme NOTIFY themeChanged)
    Q_PROPERTY(QString accent READ getAccent NOTIFY accentChanged)
    Q_PROPERTY(QString background READ getBackground NOTIFY backgroundChanged)
    Q_PROPERTY(QString foreground READ getForeground NOTIFY foregroundChanged)
    Q_PROPERTY(QString primary READ getPrimary NOTIFY primaryChanged)
    Q_PROPERTY(QString primaryForeground READ getPrimaryForeground NOTIFY primaryForegroundChanged)
    Q_PROPERTY(QString secondary READ getSecondary NOTIFY secondaryChanged)
    Q_PROPERTY(QString secondaryForeground READ getSecondaryForeground NOTIFY secondaryForegroundChanged)
    Q_PROPERTY(bool usePluginStyle READ getUsePluginStyle WRITE setUsePluginStyle NOTIFY usePluginStyleChanged)
public:
    StyleViewModel(UseCases::PluginManager& pluginManager);

    QString getTheme() const;
    QString getAccent() const;
    QString getBackground() const;
    QString getForeground() const;
    QString getPrimary() const;
    QString getPrimaryForeground() const;
    QString getSecondary() const;
    QString getSecondaryForeground() const;
    bool getUsePluginStyle() const;
    void setUsePluginStyle(bool value);

    Q_INVOKABLE double getColorScaleFactor(const QString& color);

signals:
    void themeChanged();
    void accentChanged();
    void backgroundChanged();
    void foregroundChanged();
    void primaryChanged();
    void primaryForegroundChanged();
    void secondaryChanged();
    void secondaryForegroundChanged();
    void usePluginStyleChanged();

private slots:
    void onPluginChanged(UseCases::Plugin* plugin);

private:
    void setTheme(const QString& value);
    void setAccent(const QString& value);
    void setBackground(const QString& value);
    void setForeground(const QString& value);
    void setPrimary(const QString& value);
    void setPrimaryForeground(const QString& value);
    void setSecondary(const QString& value);
    void setSecondaryForeground(const QString& value);
    void updateStyle(const UseCases::PluginStyle& newStyle);

    bool usePluginStyle;
    UseCases::PluginStyle style;
    UseCases::PluginManager& pluginManager;
};

END_MELLOWPLAYER_NAMESPACE

