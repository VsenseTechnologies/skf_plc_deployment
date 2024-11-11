#!/bin/bash

rt_temp=0
rt_pid=0
st_trp=0
st_run=1


status_counter=0
timer=0

plc_id="vs24skf01"

host="skfplc.mqtt.vsensetech.in"
port="1883"
topic="server"

step=1

time1=60
time2=60
time3=60
time4=60


while true; do
    real_time_temp="{\"RegAd\":\"302\",\"D1\":\"$rt_temp\"}"
    real_time_pid="{\"RegAd\":\"322\",\"D1\":\"$rt_pid\"}"

    blower_trip_status="{\"RegAd\":\"18\",\"D1\":\"$st_trp\"}"
    elevator_trip_status="{\"RegAd\":\"20\",\"D1\":\"$st_trp\"}"
    rotor_trip_status="{\"RegAd\":\"22\",\"D1\":\"$st_trp\"}"

    blower_run_status="{\"RegAd\":\"24\",\"D1\":\"$st_run\"}"
    elevator_run_status="{\"RegAd\":\"26\",\"D1\":\"$st_run\"}"
    rotor_run_status="{\"RegAd\":\"28\",\"D1\":\"$st_run\"}"

    recipe_step1_time="{\"RegAd\":\"124\",\"D1\":\"$time1\"}"
    recipe_step1_temp="{\"RegAd\":\"304\",\"D1\":\"$rt_temp\"}"

    recipe_step2_time="{\"RegAd\":\"126\",\"D1\":\"$time2\"}"
    recipe_step2_temp="{\"RegAd\":\"306\",\"D1\":\"$rt_temp\"}"

    recipe_step3_time="{\"RegAd\":\"128\",\"D1\":\"$time3\"}"
    recipe_step3_temp="{\"RegAd\":\"308\",\"D1\":\"$rt_temp\"}"

    recipe_step4_time="{\"RegAd\":\"130\",\"D1\":\"$time4\"}"
    recipe_step4_temp="{\"RegAd\":\"310\",\"D1\":\"$rt_temp\"}"


    # mqttx pub  -h $host -p $port -t "$plc_id/$topic" -m "$real_time_temp"
    # mqttx pub -h $host -p $port -t "$plc_id/$topic" -m "$real_time_pid"

    # mqttx pub  -h $host -p $port -t "$plc_id/$topic" -m "$blower_trip_status"
    # mqttx pub -h $host -p $port -t "$plc_id/$topic" -m "$elevator_trip_status"
    # mqttx pub -h $host -p $port -t "$plc_id/$topic" -m "$rotor_trip_status"

    # mqttx pub -h $host -p $port -t "$plc_id/$topic" -m "$blower_run_status"
    # mqttx pub -h $host -p $port -t "$plc_id/$topic" -m "$elevator_run_status"
    # mqttx pub -h $host -p $port -t "$plc_id/$topic" -m "$rotor_run_status"

    if [ $step -eq 1 ]; then
        mqttx pub -h $host -p $port -t "$plc_id/$topic" -m "$recipe_step1_time"
        mqttx pub -h $host -p $port -t "$plc_id/$topic" -m "$recipe_step1_temp"
    fi

    if [ $step -eq 2 ]; then
        mqttx pub -h $host -p $port -t "$plc_id/$topic" -m "$recipe_step2_time"
        mqttx pub -h $host -p $port -t "$plc_id/$topic" -m "$recipe_step2_temp"
    fi

    if [ $step -eq 3 ]; then
         mqttx pub -h $host -p $port -t "$plc_id/$topic" -m "$recipe_step3_time"
         mqttx pub -h $host -p $port -t "$plc_id/$topic" -m "$recipe_step3_temp"
    fi

    if [ $step -eq 4 ]; then
        mqttx pub -h $host -p $port -t "$plc_id/$topic" -m "$recipe_step4_time"
        mqttx pub -h $host -p $port -t "$plc_id/$topic" -m "$recipe_step4_temp"
    fi


    if [ $rt_temp -gt 200 ]; then
        rt_temp=0
    fi

    if [ $rt_pid -gt 20 ]; then
        rt_pid=0
    fi

    if [ $status_counter -gt 5 ]; then
        ((st_trp=!st_trp))
        ((st_run=!st_run))
        status_counter=0
    fi

    if [ $step -eq 5 ]; then
        step=1
        time1=60
        time2=60
        time3=60
        time4=60
    fi

    if [ $step -eq 1 ]; then
        ((time1 = time1 - 1))
    elif [ $step -eq 2 ]; then
        ((time2 = time2 - 1))
    elif [ $step -eq 3 ]; then
        ((time3 = time3 - 1))
    else
        ((time4=time4-1))
    fi

    if [ $timer -gt 60 ]; then
        timer=0
        ((step+=1))
    fi


    ((rt_temp+=10))
    ((rt_pid+=1))
    ((status_counter+=1))
    ((timer+=1))


    # sleep 1

done
