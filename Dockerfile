FROM centos:7 as build

WORKDIR /

RUN yum install -y genisoimage git wget make
RUN yum install -y centos-release-scl
RUN yum install -y devtoolset-7-gcc-*
RUN echo "source scl_source enable devtoolset-7" >> /etc/bashrc
RUN source /etc/bashrc

RUN git clone git://git.ipxe.org/ipxe.git

WORKDIR /ipxe/src

RUN wget http://mirror.centos.org/centos/7/os/x86_64/isolinux/isolinux.bin
COPY chainload.ipxe /ipxe/src/
RUN source /etc/bashrc
RUN make ISOLINUX_BIN=isolinux.bin EMBED=chainload.ipxe



FROM rbrayner/nginx-file-browser
COPY --from=build /ipxe/src/bin /opt/www/files
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

