profile=""
region="us-east-1"
terraform_path="deployment/terraforms"

function configure_aws() {
  echo "Enter AWS Credentials:"
  aws configure --profile $profile
  echo "Enter Again:"
  aws configure --profile $profile
}
if command -v aws --version; then
  echo "AWS CLI already present"
  configure_aws
else
  echo "Installing AWS CLI"
  apt-get install awscli
  echo "Installation Done"
  configure_aws
fi
cd $terraform_path || exit
