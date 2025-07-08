ARG PYTHON_VERSION=3.9
ARG FLASK_HOST=0.0.0.0
ARG FLASK_PORT=8080
FROM python:${PYTHON_VERSION}
WORKDIR /flask_app

# Copy in the source code
COPY . ./

# Install the application requirements
RUN pip install -r requirements.txt

# Set environment varialbe
ENV FLASK_APP=main.py

# Execute flask startup command
CMD ["flask","run","--host=${FLASK_HOST}","--port=${FLASK_PORT}"]
