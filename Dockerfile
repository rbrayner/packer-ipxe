FROM centos:7 as build

WORKDIR /
RUN yum install -y genisoimage \ 
                   git \ 
                   wget \
                   make \
                   xz \
                   xz-devel \
                   gcc \
                   gcc-c++ \ ;
    git clone git://git.ipxe.org/ipxe.git

WORKDIR /ipxe/src
RUN wget http://mirror.centos.org/centos/7/os/x86_64/isolinux/isolinux.bin
COPY chainload.ipxe /ipxe/src/

RUN make ISOLINUX_BIN=isolinux.bin EMBED=chainload.ipxe ; \
    mkdir /ipxe/src/nginx_files ; \
    cp -prf /ipxe/src/bin/ipxe.iso /ipxe/src/nginx_files/

WORKDIR /ipxe/src/nginx_files
RUN wget http://mirror.centos.org/centos/7/os/x86_64/isolinux/initrd.img ; \
    wget http://mirror.centos.org/centos/7/os/x86_64/isolinux/vmlinuz


# nginx
FROM rbrayner/nginx-file-browser
COPY --from=build /ipxe/src/nginx_files /opt/www/files
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

