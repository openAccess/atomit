if (STATIC_BUILD OR NOT USE_SYSTEM_PAHO)
  set(PAHO_SOURCES_DIR ${CMAKE_BINARY_DIR}/paho.mqtt.c-1.2.0)
  DownloadPackage(
    "6897eea98dc0a0e6fd6bed4dd3a4bbe5"
    "http://www.orthanc-server.com/downloads/third-party/atom-it/paho.mqtt.c-1.2.0.tar.gz"
    "${PAHO_SOURCES_DIR}")

  configure_file(
    ${PAHO_SOURCES_DIR}/src/VersionInfo.h.in
    ${AUTOGENERATED_DIR}/VersionInfo.h
    )

  set(PAHO_SOURCES
    ${PAHO_SOURCES_DIR}/src/Clients.c
    ${PAHO_SOURCES_DIR}/src/Heap.c
    ${PAHO_SOURCES_DIR}/src/LinkedList.c
    ${PAHO_SOURCES_DIR}/src/Log.c
    ${PAHO_SOURCES_DIR}/src/MQTTPacket.c
    ${PAHO_SOURCES_DIR}/src/MQTTPacketOut.c
    ${PAHO_SOURCES_DIR}/src/MQTTPersistence.c
    ${PAHO_SOURCES_DIR}/src/MQTTPersistenceDefault.c
    ${PAHO_SOURCES_DIR}/src/MQTTProtocolClient.c
    ${PAHO_SOURCES_DIR}/src/MQTTProtocolOut.c
    ${PAHO_SOURCES_DIR}/src/Messages.c
    ${PAHO_SOURCES_DIR}/src/Socket.c
    ${PAHO_SOURCES_DIR}/src/SocketBuffer.c
    ${PAHO_SOURCES_DIR}/src/StackTrace.c
    ${PAHO_SOURCES_DIR}/src/Thread.c
    ${PAHO_SOURCES_DIR}/src/Tree.c
    ${PAHO_SOURCES_DIR}/src/utf-8.c

    # We use the synchronous version of Paho
    #${PAHO_SOURCES_DIR}/src/MQTTAsync.c
    ${PAHO_SOURCES_DIR}/src/MQTTClient.c

    # We include SSL support
    ${PAHO_SOURCES_DIR}/src/SSLSocket.c
    )

  include_directories(
    ${PAHO_SOURCES_DIR}/src
    )

else()
  # in "paho-mqtt3cs", "c" means "MQTTClient" (not async) and "s"
  # means "with SSL support"
  set(PAHO_LIBRARY paho-mqtt3cs)
  
  CHECK_INCLUDE_FILE_CXX(MQTTClient.h HAVE_PAHO_H)
  if (NOT HAVE_PAHO_H)
    message(FATAL_ERROR "Please install the paho-devel package")
  endif()

  CHECK_LIBRARY_EXISTS(${PAHO_LIBRARY} MQTTClient_create "" HAVE_PAHO_LIB)
  if (NOT HAVE_PAHO_LIB)
    message(FATAL_ERROR "Please install the paho-devel package")
  endif()

  link_libraries(${PAHO_LIBRARY})
endif()