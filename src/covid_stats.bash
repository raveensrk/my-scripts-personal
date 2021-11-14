#!/bin/bash

set -e

# This will update my covid statistics repo
# TODO Some empty fields why? Investigate.

mkdir -p ~/tmp
pushd ~/tmp
[ -d COVID-19 ] || git clone git@github.com:CSSEGISandData/COVID-19.git
repo=~/tmp/COVID-19
pushd $repo
git pull 
head -1 "$repo/csse_covid_19_data/csse_covid_19_daily_reports/01-01-2021.csv"  |  awk -F',' '{print $1" | "$3" | "$4" | "$8" | "$9" | "$10" | "$11" | "$14}' | sed 's/FIPS/DATE/g'
grep -i india, $repo/csse_covid_19_data/csse_covid_19_daily_reports/* \
	| grep Tamil | grep "\-2021" | awk -F',' '{print $1" | "$3" | "$4" | "$8" | "$9" | "$10" | "$11" | "$14}' | sed "s/.*\///g" | sed 's/://g' | sed 's/.csv//g' | tail -n 10
popd
popd
