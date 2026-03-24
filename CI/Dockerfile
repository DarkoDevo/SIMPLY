FROM python:3.10-alpine

WORKDIR /usr/src/bundler/Obfuscator

RUN apk add git
RUN apk add luajit

RUN echo 'alias lua="luajit"' >> ~/.ashrc && echo 'source ~/.ashrc' >> ~/.profile
RUN ln -s $(which luajit) /usr/local/bin/lua

RUN git clone https://github.com/levno-710/Prometheus.git

COPY ./AutoBundle/Obfuscator/Obfuscate.py ./Obfuscate.py
COPY ./AutoBundle/Obfuscator/Config.lua ./Config.lua

WORKDIR /usr/src/bundler

COPY ./AutoBundle/requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY ./AutoBundle/Templates ./Templates
COPY ./AutoBundle/GGLGroups.py ./

RUN python ./GGLGroups.py

COPY ./AutoBundle/*.py ./

COPY ./AutoBundle/Exports ./Exports
COPY ./AutoBundle/Profiles ./Profiles
COPY ./AutoBundle/Globals.json ./

CMD ["python", "Bundler.py", "-r", "/usr/src/profiles", "-e"]
