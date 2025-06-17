#!/bin/bash

# Generate random characters
CHARACTERS=$(head /dev/urandom | LC_ALL=C tr -dc 'a-zA-Z0-9' | head -c 15)

# Generate random symbol
SYMBOL=$(echo '!@#$%^&*()_+=' | fold -w1 | shuf | head -c 1)

# Concatenate characters and symbol
PASSWORD="$CHARACTERS$SYMBOL"
echo "New password is: $PASSWORD"


