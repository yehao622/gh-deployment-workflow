#!/bin/bash

# Configuration
SERVER_IP="13.220.82.171"  # Replace with your EC2 IP
SERVER_USER="ubuntu"
SSH_KEY="~/.ssh/nginx-static-key.pem"
REMOTE_PATH="/var/www/static-site/"
LOCAL_PATH="./"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${YELLOW}🚀 Starting deployment...${NC}"

# Dry run first (optional - remove if you want)
echo -e "${YELLOW}Running dry-run to preview changes...${NC}"
rsync -avz --dry-run --delete \
    -e "ssh -i $SSH_KEY -o StrictHostKeyChecking=no" \
    --exclude 'deploy.sh' \
    --exclude '.git' \
    --exclude '.DS_Store' \
    $LOCAL_PATH $SERVER_USER@$SERVER_IP:$REMOTE_PATH

read -p "Continue with deployment? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    echo -e "${RED}Deployment cancelled${NC}"
    exit 1
fi

# Actual deployment
echo -e "${YELLOW}Deploying files...${NC}"
rsync -avz --delete \
    -e "ssh -i $SSH_KEY -o StrictHostKeyChecking=no" \
    --exclude 'deploy.sh' \
    --exclude '.git' \
    --exclude '.DS_Store' \
    $LOCAL_PATH $SERVER_USER@$SERVER_IP:$REMOTE_PATH

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Deployment successful!${NC}"
    echo -e "${GREEN}Visit: http://$SERVER_IP${NC}"
else
    echo -e "${RED}❌ Deployment failed!${NC}"
    exit 1
fi
