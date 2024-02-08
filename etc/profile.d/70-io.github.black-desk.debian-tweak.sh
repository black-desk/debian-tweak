# NOTE:
# We have configurate environment variables in /etc/environment.d.
# And we need to export PATH here again
# as PATH is the only one which is overwrited by /etc/profile.

export PATH
PATH=/opt/io.github.black-desk.debian-tweak/bin:$PATH
