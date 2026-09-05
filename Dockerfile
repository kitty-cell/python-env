# syntax=docker/dockerfile:1

ARG PYTHON_IMAGE=python:3.12.7-slim-bookworm

# Builder contains pip's temporary files and dependency installation work.
FROM --platform=linux/amd64 ${PYTHON_IMAGE} AS builder

ENV PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_NO_CACHE_DIR=1 \
    PYTHONDONTWRITEBYTECODE=1

COPY requirements.txt /tmp/requirements.txt
RUN python -m pip install \
        --no-cache-dir \
        --no-compile \
        --target=/opt/python \
        --index-url=https://pypi.org/simple \
        --extra-index-url=https://download.pytorch.org/whl/cu128 \
        -r /tmp/requirements.txt \
        "torch==2.7.1+cu128" \
        "tabpfn==8.5.0" \
        "xgboost-cu12==3.4.1" \
    && PYTHONPATH=/opt/python python -m pip check \
    && find /opt/python -type f \
        \( -name '*.pyc' -o -name '*.pyo' -o -name '*.a' \) -delete \
    && find /opt/python -type d \
        \( -name '__pycache__' -o -name 'test' -o -name 'tests' \) \
        -prune -exec rm -rf '{}' + \
    && rm -rf \
        /opt/python/torch/include \
        /opt/python/torch/share/cmake \
        /opt/python/triton \
        /opt/python/triton-*.dist-info

# The final image contains only the Python runtime and installed runtime files.
FROM --platform=linux/amd64 ${PYTHON_IMAGE} AS runtime

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PYTHONPATH=/opt/python \
    PATH=/opt/python/bin:${PATH}

COPY --from=builder /opt/python /opt/python

WORKDIR /app
RUN python -c "from importlib.metadata import version; import torch, tabpfn, xgboost; assert torch.version.cuda == '12.8'; print('torch', torch.__version__, 'tabpfn', version('tabpfn'), 'xgboost', xgboost.__version__)"

CMD ["python"]
