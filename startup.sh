#!/bin/sh
DEFAULT_ROOTPASSWORD=admin
DEFAULT_HOSTNAME=devM

if [ ${ROOTPASSWORD} ]; then
	echo "root:$ROOTPASSWORD" | chpasswd
else
	echo "root:$DEFAULT_ROOTPASSWORD" | chpasswd
fi


## create users
USER=${USER:-root}
HOME=/root
if [ "$USER" != "root" ]; then
	echo "* enable custom user: $USER"
	useradd --shell /bin/bash --user-group --groups adm,sudo $USER
	if [ -z "$PASSWORD" ]; then
		PASSWORD=${DEFAULT_ROOTPASSWORD}
		echo "set default password to $PASSWORD"
	fi

	HOME=/home/$USER
	echo "$USER:$PASSWORD" | chpasswd
	chown -R $USER:$USER ${HOME}
	cp -f /root/bash_profile   ${HOME}/.bash_profile
fi

if [ ${ADDPATH} ];then
	PATH=$PATH:$ADDPATH
	echo "* add path=$PATH"
	echo "PATH=$PATH" >>  /etc/environment
fi

rm -rf ${HOME}/.vnc
mkdir -p ${HOME}/.vnc
cp /srv/xstartup ${HOME}/.vnc/xstartup

if [ -n "$VNC_PASSWORD" ]; then
	echo -n "$VNC_PASSWORD" | vncpasswd -f > $HOME/.vnc/passwd
	export VNC_PASSWORD=
else
        echo -n "admin1234" | vncpasswd -f > $HOME/.vnc/passwd
fi
chown -R $USER:$USER ${HOME}/.vnc
chmod 400 $HOME/.vnc/passwd

su - $USER -c "vncserver  -alwaysshared -geometry $RESOLUTION :1"


exec supervisord  -c /etc/supervisord.conf
