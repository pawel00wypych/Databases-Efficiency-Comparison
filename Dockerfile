FROM mongo:8.0

# Install Python and pip
RUN apt-get update && \
    apt-get install -y python3 python3-pip && \
    pip3 install pandas pymongo && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /docker-entrypoint-initdb.d

# Ensure all init scripts are copied
COPY mongodb-init-scripts/ /docker-entrypoint-initdb.d/
COPY data/ /shared-data/

# Make shell scripts executable
RUN chmod +x /docker-entrypoint-initdb.d/*.sh

# Set default entrypoint (inherited from mongo)
