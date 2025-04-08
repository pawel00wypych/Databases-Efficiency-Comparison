FROM mongo:7.0

# Install Python and pip
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    && apt-get clean

# Create and activate a virtual environment for Python
RUN python3 -m venv /venv

# Install necessary Python packages inside the virtual environment
RUN /venv/bin/pip install --upgrade pip
RUN /venv/bin/pip install pandas pymongo

# Set the PATH to use the virtual environment's python and pip by default
ENV PATH="/venv/bin:$PATH"