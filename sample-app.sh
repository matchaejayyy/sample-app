#!/bin/bash
set -euo pipefail

rm -rf tempdir
mkdir -p tempdir/templates tempdir/static
cp sample_app.py tempdir/
cp -r templates/. tempdir/templates/
cp -r static/. tempdir/static/

printf '%s\n' 'FROM python' > tempdir/Dockerfile
printf '%s\n' 'RUN pip install flask' >> tempdir/Dockerfile
printf '%s\n' 'COPY ./static /home/myapp/static/' >> tempdir/Dockerfile
printf '%s\n' 'COPY ./templates /home/myapp/templates/' >> tempdir/Dockerfile
printf '%s\n' 'COPY sample_app.py /home/myapp/' >> tempdir/Dockerfile
printf '%s\n' 'EXPOSE 8080' >> tempdir/Dockerfile
printf '%s\n' 'CMD ["python3", "/home/myapp/sample_app.py"]' >> tempdir/Dockerfile

cd tempdir
docker build -t sampleapp .
docker rm -f samplerunning 2>/dev/null || true
docker run -t -d -p 8080:8080 --name samplerunning sampleapp
docker ps -a
