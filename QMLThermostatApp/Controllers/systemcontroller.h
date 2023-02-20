#ifndef SYSTEMCONTROLLER_H
#define SYSTEMCONTROLLER_H

#include <QObject>


class systemcontroller : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int currentSystemTemperature READ currentSystemTemperature WRITE setCurrentSystemTemperature NOTIFY currentSystemTemperatureChanged)

    Q_PROPERTY(int targetTemp READ targetTemp WRITE setTargetTemp NOTIFY targetTempChanged)

    Q_PROPERTY(QString systemStatusMessage READ systemStatusMessage WRITE setSystemStatusMessage NOTIFY systemStatusMessageChanged)

    Q_PROPERTY(HeatSelectState systemState READ systemState WRITE setSystemState NOTIFY systemStateChanged)

    Q_PROPERTY(THeatState tState READ tState WRITE setTstate NOTIFY tStateChanged)

    Q_PROPERTY(int initialTemp READ initialTemp WRITE setInitialTemp NOTIFY initialTempChanged)

public:
    explicit systemcontroller(QObject *parent = nullptr);

    enum HeatSelectState {
        ON,
        OFF
    };

    Q_ENUM(HeatSelectState)

    enum THeatState {
        TON,
        TOFF
    };

    Q_ENUM(THeatState)

    Q_INVOKABLE void increaseTemp();

    Q_INVOKABLE void decreaseTemp();

    Q_INVOKABLE void checkSystemStatus();



    int currentSystemTemperature() const;
    int targetTemp() const;
    const QString &systemStatusMessage() const;
    HeatSelectState systemState() const;
    THeatState tState() const;
    int initialTemp() const;


public slots:
    void setTargetTemp(int newTargetTemp);
    void setCurrentSystemTemperature(int newCurrentSystemTemperature);
    void setSystemStatusMessage(const QString &newSystemStatusMessage);
    void setSystemState(systemcontroller::HeatSelectState newSystemState);
    void setTstate(systemcontroller::THeatState newTstate);
    void setInitialTemp(int newInitialTemp);


signals:
    void currentSystemTemperatureChanged();
    void targetTempChanged();
    void systemStatusMessageChanged();
    void systemStateChanged();
    void tStateChanged();
    void initialTempChanged();



private:
    int m_currentSystemTemperature;
    int m_targetTemp;
    QString m_systemStatusMessage;
    HeatSelectState m_systemState;
    THeatState m_tState;
    int m_initialTemp;
};

#endif // SYSTEMCONTROLLER_H
