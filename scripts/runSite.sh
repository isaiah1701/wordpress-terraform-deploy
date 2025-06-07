#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 WordPress Terraform Deployment Script${NC}"
echo "========================================="

# Step 1: Initialize Terraform
echo -e "\n${YELLOW}📦 Initializing Terraform...${NC}"
if terraform init -upgrade=false; then
    echo -e "${GREEN}✅ Terraform initialized successfully${NC}"
else
    echo -e "${RED}❌ Terraform initialization failed${NC}"
    exit 1
fi

# Step 2: Plan deployment
echo -e "\n${YELLOW}📋 Planning deployment...${NC}"
terraform plan

# Step 3: Apply configuration
echo -e "\n${YELLOW}🏗️  Deploying WordPress infrastructure...${NC}"
if terraform apply -auto-approve; then
    echo -e "${GREEN}✅ Infrastructure deployed successfully${NC}"
else
    echo -e "${RED}❌ Deployment failed${NC}"
    exit 1
fi

# Step 4: Get the public IP
echo -e "\n${YELLOW}🔍 Getting WordPress public IP...${NC}"
WORDPRESS_IP=$(terraform output -raw wordpress_public_ip)

if [ -z "$WORDPRESS_IP" ]; then
    echo -e "${RED}❌ Could not retrieve WordPress IP${NC}"
    exit 1
fi

echo -e "${GREEN}✅ WordPress IP: $WORDPRESS_IP${NC}"

# Step 5: Wait for WordPress to be ready
echo -e "\n${YELLOW}⏳ Waiting for WordPress to be ready...${NC}"
echo "This may take 2-3 minutes for cloud-init to complete..."

# Check if site is responding (wait up to 5 minutes)
MAX_ATTEMPTS=30
ATTEMPT=1
while [ $ATTEMPT -le $MAX_ATTEMPTS ]; do
    echo -n "Attempt $ATTEMPT/$MAX_ATTEMPTS: "
    
    if curl -s --connect-timeout 10 http://$WORDPRESS_IP > /dev/null 2>&1; then
        echo -e "${GREEN}✅ WordPress is responding!${NC}"
        break
    else
        echo "Still waiting..."
        sleep 10
        ATTEMPT=$((ATTEMPT + 1))
    fi
done

# Step 6: Open the site
WORDPRESS_URL="http://$WORDPRESS_IP"
echo -e "\n${GREEN}🎉 WordPress is ready!${NC}"
echo -e "${BLUE}URL: $WORDPRESS_URL${NC}"

# Try to open in browser
echo -e "\n${YELLOW}🌐 Opening WordPress in your browser...${NC}"

# Detect OS and open browser
if command -v xdg-open > /dev/null; then
    # Linux
    xdg-open "$WORDPRESS_URL"
elif command -v open > /dev/null; then
    # macOS
    open "$WORDPRESS_URL"
elif command -v start > /dev/null; then
    # Windows
    start "$WORDPRESS_URL"
else
    echo -e "${YELLOW}⚠️  Could not auto-open browser${NC}"
    echo -e "Please manually open: ${BLUE}$WORDPRESS_URL${NC}"
fi

echo -e "\n${GREEN}🎯 Deployment Complete!${NC}"
echo -e "WordPress URL: ${BLUE}$WORDPRESS_URL${NC}"
echo -e "If the site doesn't load immediately, wait a few more minutes for setup to complete."
echo -e "\n${YELLOW}💡 To destroy resources later, run: ${NC}terraform destroy"