FROM debian:latest

# Install sudo
RUN apt update \
	&& apt upgrade -y \
	&& apt install -y  sudo

# Setting the shaun user
RUN adduser shaun && echo "shaun:shaun" | chpasswd && adduser shaun sudo \
	&& mkdir -p /home/shaun && chown shaun:shaun /home/shaun

# Setting up the variable environment 
ENV XDG_RUNTIME_DIR=/run/user/1000

# Copying test file
# COPY Ed_Sheeran_Shivers.mp3 /home/shaun/

# Install pipewpire & wireplumber
RUN sudo apt update \
	&& sudo apt upgrade -y \
	&& sudo apt install -y pipewire

#RUN sudo add-apt-repository ppa:pipewire-debian/wireplumber-upstream \
#	&& sudo apt-get update \
#	&& sudo apt upgrade -y \
#	&& sudo apt-get install wireplumber{,-doc} gir1.2-wp-0.4 libwireplumber-0.4-{0,dev}

# Install nvim
RUN sudo apt update \
	&& apt install -y neovim

# Install vlc
RUN sudo apt update \
	&& sudo apt upgrade -y \
	&& sudo apt install -y vlc 

