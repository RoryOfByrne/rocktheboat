#!/usr/bin/bash

read -rp "Author: " author
read -rp "Title: " title
read -rp "State: " state

yq -i ". += [{\"author\": \"$author\", \"title\": \"$title\", \"state\": \"$state\"}]" _data/books.yml -y
