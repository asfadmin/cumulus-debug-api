.SILENT:
.ONESHELL:
.PHONY: container-shell cloudformation


# *************** DOCKER Commands ***************
image: build/cumulus_debug_api.Dockerfile
	cd build && \
	docker build -f cumulus_debug_api.Dockerfile -t cumulus_debug_api .

container-shell:
	docker run -it --rm \
		--user `id -u` \
		-v ${PWD}:/cumulus-debug-api \
		-v ~/.aws:/.aws \
		cumulus_debug_api


# *************** AWS INIT Commands ***************
zip-lambda:
	zip -r lambda.zip lambda/*

upload-code: zip-lambda
	aws --profile ${AWS_PROFILE} s3api create-bucket --bucket ${DEPLOY_NAME}-cumulus-debug-code --region ${AWS_REGION} \
	 --create-bucket-configuration LocationConstraint=${AWS_REGION}
	aws --profile ${AWS_PROFILE} s3 cp lambda.zip s3://${DEPLOY_NAME}-cumulus-debug-code

create-template-bucket:
	aws --profile ${AWS_PROFILE} s3api create-bucket --bucket ${DEPLOY_NAME}-cumulus-dubug-cf --region ${AWS_REGION} \
         --create-bucket-configuration LocationConstraint=${AWS_REGION}

upload-template:
	aws --profile ${AWS_PROFILE} s3 cp cloudformation/cumulus_debug_api.yaml s3://${DEPLOY_NAME}-cumulus-dubug-cf

create-cloudformation:
	aws cloudformation --profile ${AWS_PROFILE} create-stack --stack-name ${DEPLOY_NAME}-cumulus-debug-api \
           --template-url https://${DEPLOY_NAME}-cumulus-dubug-cf.s3-${AWS_REGION}.amazonaws.com/cumulus_debug_api.yaml

init: upload-code create-template-bucket upload-template create-cloudformation

# *************** Cloudformation Commands ***************
update-cloudformation: upload-template
	aws cloudformation update-stack --stack-name ${DEPLOY_NAME}-cumulus-debug-api \
            --template-url https://${DEPLOY_NAME}-cumulus-dubug-cf.s3-${AWS_REGION}.amazonaws.com/cumulus_debug_api.yaml