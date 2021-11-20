#!/bin/bash

# --ytdl-format=bestvideo[height<=?1080][fps<=?30]+bestaudio/best

mpv "$1" --ytdl-format="bestvideo[height<=?720][fps<=?30]+bestaudio/best"

