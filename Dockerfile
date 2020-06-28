FROM centos:7

RUN yum install -y genisoimage git wget make

WORKDIR /
RUN git clone git://git.ipxe.org/ipxe.git

WORKDIR /ipxe/src
RUN wget http://mirror.centos.org/centos/7/os/x86_64/isolinux/isolinux.bin

RUN cat << EOF > chainload.ipxe
#!ipxe
dhcp
sleep 10
chain http://\${dhcp-server}/latest/user-data
EOF

RUN make ISOLINUX_BIN=isolinux.bin EMBED=chainload.ipxe

