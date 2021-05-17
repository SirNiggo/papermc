#!/bin/bash
if [ "$ACCEPT_EULA" == "y" ]
then
    echo "eula=true" >> eula.txt
fi

if [ -d "$BASE_CONFIG_DIR" ]; then
    if [ "$OVERWRITE_SETTINGS" == "y"]
    then
        /bin/cp -rf $BASE_CONFIG_DIR/. ./
    else
        /bin/cp -rn $BASE_CONFIG_DIR/. ./
    fi
fi

java $JAVA_OPTS -jar paper.jar