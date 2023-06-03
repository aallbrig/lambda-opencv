FROM amazonlinux

RUN yum update -y
RUN yum install gcc openssl-devel bzip2-devel libffi-devel wget tar gzip zip make zlib zlib-devel -y

# Install Python 3.9
WORKDIR /
RUN wget https://www.python.org/ftp/python/3.9.16/Python-3.9.16.tgz
RUN tar -xzvf Python-3.9.16.tgz
WORKDIR /Python-3.9.16
RUN ./configure --enable-optimizations
RUN make altinstall

# Install Python packages
RUN mkdir /packages
RUN echo "opencv-python" >> /packages/requirements.txt
RUN mkdir -p /packages/opencv-python-3.9/python/lib/python3.9/site-packages
RUN pip3.9 install -r /packages/requirements.txt -t /packages/opencv-python-3.9/python/lib/python3.9/site-packages

# Create zip files for Lambda Layer deployment
WORKDIR /packages/opencv-python-3.9/
RUN zip -r9 /packages/cv2-python39.zip .
WORKDIR /packages/
RUN rm -rf /packages/opencv-python-3.9/
