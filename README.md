# Speedtest Auto

A script for running the Ookla Speedetest via command line and outputting the results to a CSV

## Prerequisites

Install the Ookla Speedtest CLI tool: https://www.speedtest.net/apps/cli

Install the following line in your `/etc/crontab`, replacing <MYUSERACCOUNT> and /path/to:
0 */4 * * * <MYUSERACCOUNT> /path/to/speedtest-auto/run-speedtest.sh >> ~/cron_log.txt 2>&1

## Running

1. Run the script `./run-speedtest.sh`. It will run the Ruby program that performs the speedtest
2. It will run the Speedtest against the servers in ./data/server-list.txt
3. Results will be put in the CSV file ./data/speedtest-output.csv