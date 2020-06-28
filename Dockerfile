FROM centos:7

WORKDIR /

RUN yum install -y genisoimage git wget make
RUN git clone git://git.ipxe.org/ipxe.git

WORKDIR /ipxe/src

RUN wget http://mirror.centos.org/centos/7/os/x86_64/isolinux/isolinux.bin
COPY chainload.ipxe /ipxe/src/
RUN make ISOLINUX_BIN=isolinux.bin EMBED=chainload.ipxe


# production environment
FROM nginx:1.17.9-alpine
COPY --from=build /app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
