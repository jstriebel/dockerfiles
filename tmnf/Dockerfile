FROM debian:buster-slim

ENV DEBIAN_FRONTEND noninteractive

RUN dpkg --add-architecture i386 && \
	apt-get update \
	&& apt-get install -y --no-install-recommends \
		libasound2-plugins:i386 \
		libgl1-mesa-glx:i386 \
		libgl1-mesa-dri:i386 \
		pulseaudio:i386 \
		wine \
		wine32 \
	&& rm -rf /var/lib/apt/lists/*

RUN echo "\
default-server = unix:/tmp/pulseaudio.socket \n\
# Prevent a server running in the container \n\
autospawn = no \n\
daemon-binary = /bin/true \n\
# Prevent the use of shared memory \n\
enable-shm = false \n\
" > /etc/pulse/client.conf

RUN mkdir -p /home/tmnf
ENV HOME=/home/tmnf
USER 1000:1000

WORKDIR "/home/tmnf/.wine/drive_c/Program Files/TmNationsForever/"
CMD [ "wine", "TmForever.exe" ]
