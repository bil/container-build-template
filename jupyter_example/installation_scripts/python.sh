TMPDIR=/tmp
export DEBIAN_FRONTEND=noninteractive

# python + pip
apt-get -qq install python3 python3-venv
curl https://bootstrap.pypa.io/get-pip.py -o $TMPDIR/get-pip.py
python3 $TMPDIR/get-pip.py
rm $TMPDIR/get-pip.py

# clean up
apt-get -qq autoremove
apt-get -qq clean
pip cache purge
