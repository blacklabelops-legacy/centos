install
lang en_US.UTF-8
keyboard us-acentos
network --bootproto=dhcp --device=eth0 --onboot=on
auth --enableshadow --passalgo=sha512 --kickstart
rootpw doorentry
firewall --disabled
selinux --enforcing
repo --name="CentOS" --baseurl=http://mirror.centos.org/centos/7/os/x86_64/ --cost=100
repo --name="systemdcontainer" --baseurl=http://dev.centos.org/centos/7/systemd-container/ --cost=100
clearpart --all --initlabel
part / --fstype ext4 --size=1024 --grow
reboot

%packages --nobase --excludedocs
audit-libs
basesystem
bash
binutils
bzip2-libs
chkconfig
cracklib
cracklib-dicts
crontabs
coreutils
libdb
device-mapper
e2fsprogs
e2fsprogs-libs
elfutils-libelf
ethtool
expat
file-libs
filesystem
findutils
gawk
gdbm
glib2
glibc
glibc-common
grep
info
initscripts
iputils
keyutils-libs
krb5-libs
libacl
libattr
libcap
libcom_err
libgcc
libidn
libselinux
libsepol
libstdc++
libsysfs
libgcrypt
dbus-libs
libcurl
lua
libutempter
libxml2
libxml2-python
logrotate
m2crypto
mcstrans
mlocate
ncurses
ncurses-libs
neon
net-tools
nss
nss-sysinit
nss-softokn
nss-softokn-freebl
openldap
libssh2
cyrus-sasl-lib
nss-util
nspr
openssl-libs
pam
passwd
libuser
pcre
popt
procps-ng
psmisc
pygpgme
python
python-libs
python-pycurl
python-iniparse
python-urlgrabber
readline
rpm
rpm-libs
rpm-python
sed
setup
shadow-utils
centos-release
grub2
sqlite
rsyslog
tzdata
util-linux
xz
xz-libs
yum
yum-plugin-fastestmirror
yum-plugin-keys
yum-plugin-protectbase
yum-metadata-parser
yum-utils
zlib
libffi
libsemanage
vi
-systemd
systemd-container
%end

%post
# Nice feature for immutable docker containers
dd if=/dev/urandom count=50 | md5sum | passwd --stdin root
passwd -l root

#Deleting and cleaning anything I could grasp from other kickstart file examples.

yum -y remove  grub2 centos-logos hwdata os-prober gettext* \
  bind-license freetype kmod dracut firewalld dbus-glib dbus-python ebtables \
  gobject-introspection libselinux-python pygobject3-base \
  python-decorator python-slip python-slip-dbus

find /usr/share/{man,doc,info,gnome/help} \
        -type f | xargs /bin/rm

rm -rf /etc/firewalld
rm -rf /boot
rm -rf /etc/machine-id
rm -rf /usr/lib/systemd/system/multi-user.target.wants/getty.target
rm -rf /usr/lib/systemd/system/multi-user.target.wants/systemd-logind.service
rm -rf /etc/ld.so.cache
rm -rf /var/cache/ldconfig/*
rm -rf /var/cache/yum/*
rm -f /etc/rpm/macros.imgcreate

localedef --delete-from-archive $(localedef --list-archive | \
grep -v -i ^en | xargs )
mv /usr/lib/locale/locale-archive  /usr/lib/locale/locale-archive.tmpl
/usr/sbin/build-locale-archive
:>/usr/lib/locale/locale-archive.tmpl

%end
