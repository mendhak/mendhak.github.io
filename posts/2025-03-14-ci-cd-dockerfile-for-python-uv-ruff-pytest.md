---
title: A CI/CD friendly Dockerfile for `uv` based Python projects
description: A Dockerfile in multiple stages for running Python applications with uv, fuff, and pytest
tags:
  - uv
  - python
  - ruff
  - pytest
  - ci
  - cd
  - docker

---

I have been looking at using `uv` for a Python project, and I'm quite satisfied with the productivity and performance it brings to the table for a local development environment. 

Currently, I find its documentation and examples could do with improvement in terms of CI/CD and Docker deployments; most examples and blog posts seem to focus on the final mile of _running_ the application in a container, but I am not able to find much that covers the end to end of building, testing, and running the application.  

I have created a Dockerfile that would be suitable for running the application in a CI/CD pipeline, and also for running the tests. This Dockerfile assumes a Python project that makes use of `uv` for dependency management and running of tools.


```dockerfile
# This is the test runner image. It is used to run tests and linters. 
FROM ghcr.io/astral-sh/uv:python3.13-bookworm-slim AS testrunner


ENV UV_COMPILE_BYTECODE=1 UV_LINK_MODE=copy

# Tell UV to use the Docker provided Python, don't download. 
ENV UV_PYTHON_DOWNLOADS=0

WORKDIR /app
ADD . /app
# Install all dependencies, regular and dev
RUN uv sync --frozen 

RUN uv run pytest
RUN uv run ruff check
# RUN uv run any_other_tools_you_have

# This builder image will only install the main dependencies, not the dev dependencies.  
FROM ghcr.io/astral-sh/uv:python3.13-bookworm-slim AS builder

ENV UV_COMPILE_BYTECODE=1 UV_LINK_MODE=copy

# Tell UV to use the Docker provided Python, don't download. 
ENV UV_PYTHON_DOWNLOADS=0

WORKDIR /app
ADD . /app
# This time, don't install dev dependencies
RUN uv sync --frozen --no-group dev 
RUN uv pip list 

# This is the runtime image. It will only contain the dependencies needed to run the application.
FROM python:3.13-slim AS runtime

COPY --from=builder --exclude=tests --chown=app:app /app /app

ENV PATH="/app/.venv/bin:$PATH"

WORKDIR /app

CMD [ "python3", "src/my_application.py" ] 
```

## Explanation

The Dockerfile is split into three stages, for good reasons. 

The **first** stage is to aimed at continuous integration; it installs all the dependencies including dev dependencies, and runs the tests and linters. It's based on the officially provided `uv` images. 

The second and third stages are aimed at the deployment phase. 

The **second** stage installs just the main, not dev, dependencies, hence the `--no-group dev` flag. It may appear a bit repetitive, but we should be aiming to keep our security footprint as small as possible, and only install what's needed. At the same time, it's not a simple matter of just copying the entire .venv directory from one stage to another. 

The **third** stage is the actual runtime image, where the application will be run. It's based on the official Python image, as we should ideally make sure our application can run in a standard Python environment and not depend on any configuration magic that `uv` or future tools may provide. For the same security reasons as the second stage, the `--exclude` flag is used during `COPY` so we're just deploying application files. 


## References

I have pieced this together from various sources including the [official examples](https://github.com/astral-sh/uv-docker-example), and [various](https://www.saaspegasus.com/guides/uv-deep-dive/) [blogposts](https://hynek.me/articles/docker-uv/). 

My aim is for readability and maintainability, so there are some optimizations I have eschewed in favour of clarity. 


