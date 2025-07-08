ARG PYTHON_VERSION=3.9
FROM python:${PYTHON_VERSION}
WORKDIR /flask_app

# Copy in the source code
COPY . ./

# Install the application requirements
RUN pip install -r requirements.txt

# Set environment varialbe
ENV FLASK_APP=main.py
ENV FLASK_HOST=0.0.0.0
ENV FLASK_PORT=8080

# Make entrypoint executable
RUN chmod +x ./entrypoint.sh
# Execute flask startup command
ENTRYPOINT [ "./entrypoint.sh" ]