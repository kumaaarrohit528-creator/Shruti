# -------------------------------
# Base image: Python + NodeJS
# -------------------------------
FROM nikolaik/python-nodejs:python3.10-nodejs20

# -------------------------------
# Install system dependencies safely
# -------------------------------
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl \
    tar \
    xz-utils \
    aria2 \
    gnupg \
    ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# -------------------------------
# Add Yarn public key & repo (for Node packages)
# -------------------------------
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# -------------------------------
# Download & install latest static ffmpeg
# -------------------------------
RUN curl -L https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz \
    -o ffmpeg.tar.xz && \
    tar -xJf ffmpeg.tar.xz && \
    mv ffmpeg-*-static/ffmpeg /usr/local/bin/ && \
    mv ffmpeg-*-static/ffprobe /usr/local/bin/ && \
    rm -rf ffmpeg*

# -------------------------------
# Copy bot files
# -------------------------------
COPY . /app/
WORKDIR /app/

# -------------------------------
# Install Python dependencies
# -------------------------------
RUN pip3 install --no-cache-dir -r requirements.txt

# -------------------------------
# Start bot
# -------------------------------
CMD ["bash", "start"]
