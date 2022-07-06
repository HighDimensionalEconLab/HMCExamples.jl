# copied from https://hub.docker.com/r/mathworks/matlab
# test locally for syntax error by running
# docker build -t gridmatlab:latest -f matlab.dockerfile .

FROM mathworks/matlab

# mandatory for Grid.ai
WORKDIR /gridai/project
COPY . .

RUN wget https://launchpad.net/ubuntu/+archive/primary/+sourcefiles/dynare/5.1-2build1/dynare_5.1.orig.tar.xz
RUN tar -xf dynare_5.1.orig.tar.xz
RUN sudo apt install net-tools