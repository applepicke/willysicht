#!/usr/bin/bash

cd scripts/top_bar && \
echo $(sh ./time_script)@$(sh ./date_script)@$(sh ./battery_percentage_script)%@$(sh ./battery_charging_script)@$(sh ./wifi_status_script)@$(sh ./getVolumeStat.sh) && \
cd ../..

