#!/bin/bash

# Create .env file if it doesn't exist
touch .env

# Update environment variables
echo "NEXT_PUBLIC_CONTACT_PHONE=\"$NEXT_PUBLIC_CONTACT_PHONE\"" > .env
echo "NEXT_PUBLIC_CONTACT_EMAIL=\"$NEXT_PUBLIC_CONTACT_EMAIL\"" >> .env
echo "NEXT_PUBLIC_GITHUB_USERNAME=\"$NEXT_PUBLIC_GITHUB_USERNAME\"" >> .env

# Print confirmation
echo "Environment variables have been updated"
