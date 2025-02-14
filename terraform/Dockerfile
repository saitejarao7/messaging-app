# Use the official Terraform image
FROM hashicorp/terraform:latest

# Set the working directory inside the container
WORKDIR /terraform

# Copy Terraform files into the container
COPY . /terraform

# Initialize Terraform
RUN terraform init

# Use ENTRYPOINT to run Terraform apply and keep the container running
ENTRYPOINT ["/bin/sh", "-c", "terraform apply -auto-approve && tail -f /dev/null"]
