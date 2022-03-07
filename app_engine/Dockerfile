FROM ctfd/ctfd:3.4.1

# apply patches
WORKDIR /opt/CTFd
COPY ./patch.txt /opt/CTFd/patch.txt
RUN patch -s -p1 < patch.txt

