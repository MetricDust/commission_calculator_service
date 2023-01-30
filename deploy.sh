profile=""
region="us-east-1"
terraform_path="deployment/terraforms"
stack="commission"
stage="beta"
while test $# -gt 0;do
  case "$1" in
  --profile)
    shift
    profile=$1
    shift
    ;;
  --region)
    shift
    region=$1
    shift
    ;;
  --stage)
    shift
    stage=$1
    shift
    ;;
  --s3_backup_folder_name)
    shift
    s3_backup_folder_name=$1
    shift
    ;;
  *)
    echo "-$1 is not a recognized flag!"
    continue 1
    ;;
  esac
done

function build() {
  echo "Started Building"
  mkdir "$PWD/build"
  mkdir "$PWD/build/package"
  mkdir "$PWD/build/artifacts"
  echo "started building requirements ..."
  pip3 install -r requirements.txt -t "$PWD/build/package"

  echo "installed successful"
  #pip install boto3 -t "$PWD/build/package"
  cp -r "$PWD/src"/* "$PWD/build/package"
  echo "building completed ..."
}
if [[ -d "$PWD/build/" ]]; then
  echo "folder present ..."
  echo "removing build folder"
  rm -r "$PWD/build/"
  echo "building ..."
  build
else
  echo "folder not present ..."
  build
fi
cd $terraform_path || exit

echo "deleting local tf files"
rm -rf .terraform .terraform.lock.hcl out.tfplan terraform.tfplan

export AWS_PROFILE=$profile

auth_by_apikey_authorizer_lambda_details=""
echo "auth details"
echo $auth_by_apikey_authorizer_lambda_details
export s3_backup_folder="Terraforms/$stage.$s3_backup_folder_name/deploy/terraform.tfstate"
export s3_backup_bucket="metric-dust-backup-and-configurations"
export s3_backup_region="us-east-1"
export COMMISSION_SERVICE_BUCKET_NAME="commission-service"

now_epoch=$(date +%s)
echo "copying existing state for backup"
aws s3 cp "s3://$s3_backup_bucket/$s3_backup_folder" "s3://$s3_backup_bucket/$s3_backup_folder.$now_epoch" --profile $profile --region $s3_backup_region
echo "backup copied"

terraform init -backend=true -force-copy \
  -input=false \
  -backend-config "bucket=$s3_backup_bucket" \
  -backend-config "key=$s3_backup_folder" \
  -backend-config "region=$s3_backup_region"
terraform plan -var="profile=$profile" -var="region=$region" -var="stage"=$stage \
  -var="bucketName=$COMMISSION_SERVICE_BUCKET_NAME" \
  -var="s3_backup_bucket=$s3_backup_bucket" -var="s3_backup_folder=$s3_backup_folder" -var="s3_backup_region=$s3_backup_region" \
  -var="auth_by_apikey_authorizer_lambda_details=$auth_by_apikey_authorizer_lambda_details" \
  -out terraform.tfplan -lock=false


terraform apply -lock=false terraform.tfplan

cd ../../
cd $PWD
bash tests.sh
status=$?
if test $status -eq 0; then
  echo "All Tests are successful"
else
  echo "One or more tests failed, exiting deployment."
fi
