#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${RED}🔥 WordPress Terraform Destroy Script${NC}"
echo "======================================="

# Step 1: Check if Terraform state exists
if [ ! -f "terraform.tfstate" ] && [ ! -f ".terraform/terraform.tfstate" ]; then
    echo -e "${YELLOW}⚠️  No Terraform state found. Nothing to destroy.${NC}"
    exit 0
fi

# Step 2: Show current resources
echo -e "\n${YELLOW}🔍 Checking current WordPress resources...${NC}"

# Get WordPress IP if it exists
if terraform output wordpress_public_ip > /dev/null 2>&1; then
    WORDPRESS_IP=$(terraform output -raw wordpress_public_ip 2>/dev/null)
    if [ ! -z "$WORDPRESS_IP" ]; then
        echo -e "${BLUE}Current WordPress URL: http://$WORDPRESS_IP${NC}"
    fi
fi

# Show what will be destroyed
echo -e "\n${YELLOW}📋 Planning destruction...${NC}"
terraform plan -destroy

# Step 3: Confirmation prompt
echo -e "\n${RED}⚠️  WARNING: This will permanently destroy your WordPress site!${NC}"
echo -e "${YELLOW}This action cannot be undone.${NC}"
echo ""
read -p "Are you sure you want to destroy all resources? (type 'yes' to confirm): " confirmation

if [ "$confirmation" != "yes" ]; then
    echo -e "${GREEN}✅ Destruction cancelled. Your resources are safe.${NC}"
    exit 0
fi

# Step 4: Final confirmation
echo -e "\n${RED}🚨 FINAL WARNING: Destroying infrastructure in 5 seconds...${NC}"
echo -e "${YELLOW}Press Ctrl+C to cancel${NC}"
for i in {5..1}; do
    echo -n "$i... "
    sleep 1
done
echo ""

# Step 5: Destroy infrastructure
echo -e "\n${RED}🔥 Destroying WordPress infrastructure...${NC}"
if terraform destroy -auto-approve; then
    echo -e "${GREEN}✅ Infrastructure destroyed successfully${NC}"
else
    echo -e "${RED}❌ Destruction failed${NC}"
    echo -e "${YELLOW}You may need to manually clean up resources in AWS Console${NC}"
    exit 1
fi

# Step 6: Clean up local files
echo -e "\n${YELLOW}🧹 Cleaning up local Terraform files...${NC}"
read -p "Do you want to remove local Terraform state files? (y/N): " cleanup

if [[ $cleanup =~ ^[Yy]$ ]]; then
    rm -f terraform.tfstate*
    rm -f .terraform.lock.hcl
    rm -rf .terraform/
    echo -e "${GREEN}✅ Local files cleaned up${NC}"
else
    echo -e "${YELLOW}ℹ️  Local state files preserved${NC}"
fi

# Step 7: Success message
echo -e "\n${GREEN}🎯 Destruction Complete!${NC}"
echo -e "${BLUE}Your WordPress site and all AWS resources have been destroyed.${NC}"
echo -e "${YELLOW}💰 This should stop any AWS charges for these resources.${NC}"

# Optional: Show cost estimate
echo -e "\n${YELLOW}💡 Tip: Check your AWS billing dashboard to confirm no charges are accruing.${NC}"
echo -e "${BLUE}To deploy again, run: ${NC}./scripts/runSite.sh"