# Use official HashiCorp Terraform image
FROM hashicorp/terraform:latest

# Set the working directory inside the container
WORKDIR /terraform

# Copy the Terraform files into the container
COPY . /terraform

# Initialize Terraform
RUN terraform init

# Run Terraform apply and then exit
CMD ["terraform", "apply", "-auto-approve"] && tail -f /dev/null