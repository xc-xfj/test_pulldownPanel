#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "screenimageprovider.h"
#include "pulldownmanager.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    PullDownManager pulldownManager;
    ScreenImageProvider *screenImage = new ScreenImageProvider(QQmlImageProviderBase::Pixmap);
    engine.addImageProvider("screenImage", screenImage);
    engine.rootContext()->setContextProperty("PulldownManager", &pulldownManager);
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    engine.load(QUrl(QStringLiteral("qrc:/StatusBar.qml")));

    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
