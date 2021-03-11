#!/bin/bash
set -e
if [ ! -z "$WAIT_FOR_HOST" ]
then
echo "wait for host $WAIT_FOR_HOST to be ready"
if [ -z "$WAIT_FOR_TIME_OUT" ]
then
export WAIT_FOR_TIME_OUT=60
fi
echo "./wait-for-it.sh $WAIT_FOR_HOST  $WAIT_FOR_TIME_OUT"
./wait-for-it.sh $WAIT_FOR_HOST  $WAIT_FOR_TIME_OUT

fi


case "$1" in
  manager)
    exec java -Dlog4j.configuration=file:config/tools-log4j.properties -server -cp uReplicator-Manager/target/uReplicator-Manager-2.0.1-SNAPSHOT-jar-with-dependencies.jar com.uber.stream.kafka.mirrormaker.manager.ManagerStarter ${@:2}
  ;;
  controller)
    exec java -Dlog4j.configuration=file:config/tools-log4j.properties -server -cp uReplicator-Controller/target/uReplicator-Controller-2.0.1-SNAPSHOT-jar-with-dependencies.jar com.uber.stream.kafka.mirrormaker.controller.ControllerStarter ${@:2}
  ;;
  worker)
    exec java -Dlog4j.configuration=file:config/tools-log4j.properties -server -cp uReplicator-Worker-3.0/target/uReplicator-Worker-3.0-2.0.1-SNAPSHOT-jar-with-dependencies.jar  com.uber.stream.ureplicator.worker.WorkerStarter ${@:2}
  ;;
  *)
    exec $@
  ;;
esac