#!/bin/bash

# Take a html file and get only urls
# This regex is taken from `urlview` program

sed 's/"/\n/g' $1 | grep -E '(((http|https|ftp|gopher)|mailto)[.:][^ >"\t]*|www\.[-a-z0-9.]+)[^ .,;\t>">\):]'

