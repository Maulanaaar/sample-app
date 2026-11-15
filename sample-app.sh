#!/bin/bash

set -e

rm -rf tempdir

mkdir -p tempdir/templates
mkdir -p tempdir/static

cp sample_app.py tempdir/.
cp -r templates/* tempdir/templates/.
cp -r static/* tempdir/static/.

cat > tempdir/Dockerfile <<'EOF'
FROM python
RUN pip install --no-cache-dir --progress-bar off flask
COPY ./static /home/myapp/static/
COPY ./templates /home/myapp/templates/
COPY sample_app.py /home/myapp/
EXPOSE 5050
CMD ["python3", "/home/myapp/sample_app.py"]
EOF

cd tempdir

docker build -t sampleapp .

docker rm -f samplerunning >/dev/null 2>&1 || true

docker run -t -d -p 5050:5050 --name samplerunning sampleapp

docker ps -a
