#include <QTimer>
#include <QProcess>
#include <QEventLoop>
#include <QRandomGenerator>
#include "sysinfoprovider.h"

MeasureWorker *pMeasureThread;

SysInfoProvider::SysInfoProvider(QObject *parent)
{
    pMeasureThread = new MeasureWorker(this);

    if (QSysInfo::kernelType() == "winnt")
    {
        const QString cpuname_cmd = "wmic";
        const QString cpuname_arg = R"(cpu get MaxClockSpeed,name /format:list)";

        QString result = "";
        QEventLoop looper;
        QProcess *p = new QProcess(&looper);
        p->setReadChannel(QProcess::StandardOutput);
        p->setProcessChannelMode(QProcess::MergedChannels);
        QObject::connect(p, &QProcess::finished, &looper, &QEventLoop::quit);
        QObject::connect(p, &QProcess::errorOccurred, [=](QProcess::ProcessError error){qDebug() << "ProcessError = " << error << Qt::endl;});
        QObject::connect(p, &QProcess::errorOccurred, &looper, &QEventLoop::quit);
        QObject::connect(p, &QProcess::readyReadStandardOutput, [p,&result]()->void{result = p->readAllStandardOutput();});

        p->start(cpuname_cmd, cpuname_arg.split(" "));
        looper.exec();

        //
        // The returned string comsists of theMaxClockSpeed and Name values.
        // For example,
        //
        // MaxClockSpeed=2600
        // Name=13th Gen Intel(R) Core(TM) i9-13900HK

        // Remove leading and trailing whitespace
        result = result.trimmed();

        // Split the string into individual key-value pairs
        QStringList keyValuePairs = result.split("\r\r\n");

        // Create a map to store the key-value pairs
        QMap<QString, QString> keyValueMap;

        // Iterate over the key-value pairs and add them to the map
        foreach (const QString &pair, keyValuePairs) {
            if (!pair.isEmpty()) {
                int equalsIndex = pair.indexOf('=');
                if (equalsIndex != -1) {
                    QString key = pair.left(equalsIndex);
                    QString value = pair.right(pair.length() - equalsIndex - 1);
                    keyValueMap[key] = value;
                }
            }
        }

        // Set the two values to the members
        m_cpuName = keyValueMap["Name"];                            // CPU Name value
        m_cpuFreq = keyValueMap["MaxClockSpeed"].toUInt();          // MaxClockspeed value in Mhz
    }
}

SysInfoProvider::~SysInfoProvider()
{
    if (pMeasureThread)
        delete pMeasureThread;
}


void SysInfoProvider::startMeasureCPUFreq()
{
    if (pMeasureThread) {
        if (!pMeasureThread->m_started) {
            pMeasureThread->start();
            pMeasureThread->m_started = true;
        }
    }
}

void SysInfoProvider::stopMeasureCPUFreq()
{
    if (pMeasureThread) {
        pMeasureThread->m_started = false;
    }
}
