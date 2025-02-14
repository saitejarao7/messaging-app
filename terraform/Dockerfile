# Use official HashiCorp Terraform image
FROM hashicorp/terraform:latest

# Set the working directory inside the container
WORKDIR /terraform

# Copy the Terraform files into the container
COPY . /terraform

# Initialize Terraform
RUN terraform init

# Default command - Start a shell session for manual execution
CMD ["/bin/sh"]
