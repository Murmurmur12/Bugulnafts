TEMPLATE = app
CONFIG += console c++20
CONFIG -= app_bundle
CONFIG -= qt

QMAKE_CXXFLAGS += -std=c++20

SOURCES += main.cpp

INCLUDEPATH += $$PWD/include
INCLUDEPATH += /opt/homebrew/include
INCLUDEPATH += /usr/local/include

LIBS += -L/opt/homebrew/lib
LIBS += -L/usr/local/lib
LIBS += -lTgBot -lcurl -lssl -lcrypto -lpthread
