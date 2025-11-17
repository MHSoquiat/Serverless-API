# Serverless API with Lambda, API Gateway, and Output Delivery with Amazon SES

## Description

This repository contains the executable code for my Serverless API, together with execution steps and setup to try on your own environment. This project configures AWS Lambda, Amazon API Gateway, and IAM using Terraform. This project's end goal is a fully provisioned, serverless HTTP API accessible via public URL, delivered and sent to your email address. Fully managed by Infrastructure as Code and deployed via GitOps principles

## Requirements

### Architecture Diagram

Here is the architecture diagram for this project:

![System Architecture](./output/reqs/Projects.png)

### Resources

1. AWS Lambda
2. AWS Lambda Function File
3. AWS API Gateway
4. IAM Execution Role
5. IAM Policy Attachment

### Prerequisites

1. GitLab Environment Variables Setup
2. Manually provisioned S3 Bucket for statefile and statelock
3. Fully Setup Amazon SES

## Execution

### Statefile Storage and Locking

>[!NOTE]
>If you have an existing s3 bucket provisioned, you can skip this part

We will set up an S3 bucket to store our statefile and statelock. Run the `statefile-locking` configuration file using the following execution commands:

    ```bash
    # change directory
    cd statefile-locking

    # This command will initialize your folder and terraform to install the necessary extensions for the task required.
    terraform init

    # This command will layout all the resources that terraform will deploy in your AWS account. 
    terraform plan

    # After making sure you are deploying the correct resources, execute this command to deploy all the resources to your AWS Account.
    terraform apply
    ```

>[!WARNING]
>Before executing terraform init, ensure that you already have terraform set up in your local device, otherwise, it will not work

>[!NOTE]
>Before executing terraform plan, ensure that you already have your Access Key and Secret Access Key ready. It will be asked during the running process for security measures.

If you don't have `terraform` set up in your local device, follow this documentation:

:point_right: [Install Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

Here are the expected output after `terraform apply`:

![Terraform Apply](./output/s3/apply.png)

> Make sure to save the output of your apply as it will be used for the backend configuration of the system.

![S3 Dashboard](./output/s3/s3-dash.png)


### Amazon SES Setup

To setup your Amazon SES, follow this steps:

1. Navigate to Amazon Simple Email Service in your AWS Management Console and you will be prompted to the screen below, and click Get Started:

![Amazon SES Get Started](./output/ses/00.png)

2. Once you click get started, you will be prompted to this screen where you will provide a valid email address, one where you can verify. Click Next once you're finished filling out your email address.

![Amazon SES Email](./output/ses/01.png)

3. For the next page, you will be tasked to enter your domain. Please do so.

![Amazon SES Domain](./output/ses/02.png)

>[!NOTE]
>If you don't have your own domain, it's okay, just enter a random unique domain, using the verified email is enough to successfully demonstrate this project. 

4. For steps 3-5, you don't have to change anything and just press next until you reach step 6, where you will have to review the details of your setup. Once you confirmed that everything is good and accurate, you can proceed to get started with Amazon SES.

![Amazon SES 3](./output/ses/03.png)

![Amazon SES 4](./output/ses/04.png)

![Amazon SES 5](./output/ses/05.png)

### GitLab Setup



### Running the Pipeline



## Features

Test the following features for this System:

- [ ] Successful delivery of email to your chosen recipient
- [ ] Access the Public HTTP Endpoint URL and see the message
- [ ] CloudWatch Logs and Live Trail
- [ ] Change the message of the API in the Lambda Function and observe the pipeline

> This project is continuously updated and maintained to accommodate changes in AWS and Terraform

If you like this project, let's connect on the following social media platforms:
- :point_right: [LinkedIn](https://www.linkedin.com/in/soqwapo/)
- :point_right: [Instagram](https://www.instagram.com/soqwapo/)