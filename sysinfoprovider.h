#ifndef SYSINFOPROVIDER_H
#define SYSINFOPROVIDER_H

#include <QObject>
#include <QThread>
#include <QSysInfo>
#include <qqml.h>
#include <windows.h>

class SysInfoProvider : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QByteArray bootUniqueId READ bootUniqueId CONSTANT)
    Q_PROPERTY(QString currentCpuArchitecture READ currentCpuArchitecture CONSTANT)
    Q_PROPERTY(QString kernelType READ kernelType CONSTANT)
    Q_PROPERTY(QString kernelVersion READ kernelVersion CONSTANT)
    Q_PROPERTY(QString machineHostName READ machineHostName CONSTANT)
    Q_PROPERTY(QByteArray machineUniqueId READ machineUniqueId CONSTANT)
    Q_PROPERTY(QString prettyProductName READ prettyProductName CONSTANT)
    Q_PROPERTY(QString productType READ productType CONSTANT)
    Q_PROPERTY(QString productVersion READ productVersion CONSTANT)
    Q_PROPERTY(QString cpuName MEMBER m_cpuName CONSTANT)
    Q_PROPERTY(uint cpuFreq MEMBER m_cpuFreq CONSTANT)
    QML_ELEMENT
public:
    explicit SysInfoProvider(QObject *parent = nullptr);
    ~SysInfoProvider();

    // QSysinfo static functions
    QByteArray bootUniqueId() const {return QSysInfo::bootUniqueId();}
    QString	currentCpuArchitecture() {return QSysInfo::currentCpuArchitecture();}
    QString	kernelType() {return QSysInfo::kernelType();}
    QString	kernelVersion() {return QSysInfo::kernelVersion();}
    QString	machineHostName() {return QSysInfo::machineHostName();}
    QByteArray	machineUniqueId() {return QSysInfo::machineUniqueId();}
    QString	prettyProductName() {return QSysInfo::prettyProductName();}
    QString	productType() {return QSysInfo::productType();}
    QString	productVersion() {return QSysInfo::productVersion();}

public slots:
    void startMeasureCPUFreq();
    void stopMeasureCPUFreq();

signals:
    void measureCPUFreqEvent(const uint);

private:
    QString m_cpuName = "";
    uint m_cpuFreq = 0;

};

class MeasureWorker : public QThread
{
private:
    LARGE_INTEGER freq, start_cnt, end_end;
    SysInfoProvider *pSysProvider;
    const int iterations = 100000000;   // Number of iterations to perform
    const int event_duration = 1;       // The duration of raising an event (1 sec)

public:

    bool m_started = false;

    MeasureWorker(SysInfoProvider *provider ) : pSysProvider(provider) {
        QueryPerformanceFrequency(&freq);
    }

    void run() override
    {
        while (m_started) {
            // Measure start time
            QueryPerformanceCounter(&start_cnt);

            // Code to be executed in the thread
            // Execute a large number of NOP instructions
            volatile long long sum = 0;
            for (int i = 0; i < iterations; ++i) {
                sum += i; // This is a placeholder for CPU work
            }

            // Measure end time
            QueryPerformanceCounter(&end_end);

            // Calculate elapsed time in seconds
            double elapsedTime = (double)(end_end.QuadPart - start_cnt.QuadPart) / freq.QuadPart;

            // Estimate CPU frequency (assuming 1 NOP = 1 cycle, which is a simplification)
            double cpuFrequency = iterations / elapsedTime;

            if(pSysProvider)
                emit pSysProvider->measureCPUFreqEvent(cpuFrequency);

            QThread::sleep(event_duration);
        }
    }
};

#endif // SYSINFOPROVIDER_H
