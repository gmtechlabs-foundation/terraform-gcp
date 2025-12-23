FROM google/cloud-sdk:slim

# Install dependencies
RUN apt-get update && \
    apt-get install -y wget unzip bash && \
    apt-get clean

# Install Terraform
ENV TF_VERSION=1.14.0
RUN wget https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip \
    && unzip terraform_${TF_VERSION}_linux_amd64.zip \
    && mv terraform /usr/local/bin/ \
    && rm terraform_${TF_VERSION}_linux_amd64.zip

# Keep container alive
CMD ["bash"]
