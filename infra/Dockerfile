# Custom Image For Intel Optimized ML Library Change To Your Choice
FROM intel/intel-optimized-ml:latest

RUN apt-get update && apt-get install -y python3-venv curl git bash

# Install GitHub CLI
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list
RUN apt-get update && apt-get install -y gh
COPY infra/requirements.txt /tmp/requirements.txt

# Create virtual environment and install dependencies feel free to change to conda, poetry, vu or anything else
RUN python3 -m venv /opt/venv && \
    /opt/venv/bin/pip install -r /tmp/requirements.txt

COPY ../. /tmp/SPCSDataScience
RUN /opt/venv/bin/pip install /tmp/SPCSDataScience

# Set up a non-root user
RUN useradd -m jupyter
USER jupyter
WORKDIR /home/jupyter

USER root
RUN chown -R jupyter:jupyter /home/jupyter
USER jupyter
EXPOSE 8080

# Set environment variables to help secure your Jupyter server with one more layter of protection obviously change it to a different token
ENV JUPYTER_TOKEN="my_secure_token"
ENV JUPYTER_PORT=8080

# Development entrypoint for jupyter lab
ENTRYPOINT ["/bin/bash", "-c", "source /opt/venv/bin/activate && jupyter lab --allow-root --ip=0.0.0.0 --port=${JUPYTER_PORT} --no-browser --NotebookApp.token=${JUPYTER_TOKEN}"]