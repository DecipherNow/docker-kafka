#!/bin/bash

# Copyright 2019 Decipher Technology Studios
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FILES=("/etc/kafka/server.properties" )
PATTERN="^(.*)=(.*)$"
VARIABLES=("$(env)")

for file in ${FILES[@]}
do
    for variable in ${VARIABLES[@]}
    do
        if [[ ${variable} =~ ${PATTERN} ]]
        then
            name="${BASH_REMATCH[1]}"
            value="${BASH_REMATCH[2]}"
            sed -i 's=${'"${name}"'}='"${value}"'=g' "${file}"
        fi
    done
    
    KAFKA_BROKER_ID=${HOSTNAME##*-}
    KAFKA_BROKER_ID=${KAFKA_BROKER_ID:-"0"}
    sed -i 's=${BROKER_ID}='"${KAFKA_BROKER_ID}"'=g' "${file}"

done

exec "$@"
