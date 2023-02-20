#include "systemcontroller.h"

systemcontroller::systemcontroller(QObject *parent)
    : QObject(parent), m_currentSystemTemperature(25),
      m_targetTemp(70),
      m_systemStatusMessage("Default"),
      m_systemState(OFF),
      m_tState(TOFF),
      m_initialTemp(20)
{
      m_currentSystemTemperature = m_initialTemp;
}

int systemcontroller::currentSystemTemperature() const
{
    return m_currentSystemTemperature;
}

void systemcontroller::setCurrentSystemTemperature(int newCurrentSystemTemperature)
{
    if (m_currentSystemTemperature == newCurrentSystemTemperature)
        return;
    m_currentSystemTemperature = newCurrentSystemTemperature;
    emit currentSystemTemperatureChanged();
}

int systemcontroller::targetTemp() const
{
    return m_targetTemp;
}


void systemcontroller::setTargetTemp(int newTargetTemp)
{
    if (m_targetTemp == newTargetTemp)
        return;
    m_targetTemp = newTargetTemp;
    emit targetTempChanged();
    checkSystemStatus();
}

int systemcontroller::initialTemp() const
{
    return m_initialTemp;
}

void systemcontroller::setInitialTemp(int newInitialTemp)
{
    if(m_initialTemp == newInitialTemp)
    {
        return;
    }
    m_initialTemp = newInitialTemp;
    emit initialTempChanged();
}


const QString &systemcontroller::systemStatusMessage() const
{
    return m_systemStatusMessage;
}

void systemcontroller::setSystemStatusMessage(const QString &newSystemStatusMessage)
{
    if (m_systemStatusMessage == newSystemStatusMessage)
        return;
    m_systemStatusMessage = newSystemStatusMessage;
    emit systemStatusMessageChanged();
}


systemcontroller::HeatSelectState systemcontroller::systemState() const
{
    return m_systemState;
}

void systemcontroller::setSystemState(HeatSelectState newSystemState)
{
    if (m_systemState == newSystemState)
        return;
    m_systemState = newSystemState;
    emit systemStateChanged();
    checkSystemStatus();
}

systemcontroller::THeatState systemcontroller::tState() const
{
    return m_tState;
}

void systemcontroller::setTstate(THeatState newTstate)
{
    if (m_tState == newTstate)
        return;
    m_tState = newTstate;
    emit tStateChanged();
    checkSystemStatus();
}

void systemcontroller::checkSystemStatus()
{
    if((m_currentSystemTemperature < m_targetTemp) && (m_systemState == ON))
    {
        setSystemStatusMessage("ON - Heating...");
        m_tState = TON;
    }
    else if((m_currentSystemTemperature >= m_targetTemp) && (m_systemState == ON))
    {
        setSystemStatusMessage("OFF - Cooling...");
        m_tState = TOFF;
    }
    else if(m_systemState == OFF)
    {
       m_tState = TOFF;
       setSystemStatusMessage("OFF - Cooling...");
       //tuka m_currentSystemTemperature treba da se namaluva do m_initialTemp
    }
}


void systemcontroller::increaseTemp()
{
    m_currentSystemTemperature++;

}


void systemcontroller::decreaseTemp()
{
    m_currentSystemTemperature--;
}


