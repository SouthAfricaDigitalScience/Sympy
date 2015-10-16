#!/bin/bash -e
#SOURCE_FILE=$NAME-$VERSION.tar.gz
. /usr/share/modules/init/bash
# We will build the code from the github repo, but if we want specific versions,
# a new Jenkins job will be created for the version number and we'll provide
# the URL to the tarball in the configuration.
SOURCE_REPO="https://github.com/sympy/sympy/releases/download/sympy-0.7.6.1/"
# We pretend that the $SOURCE_FILE is there, even though it's actually a dir.
SOURCE_FILE="${NAME}-${VERSION}.tar.gz"
module load ci
echo "Modules available"
module avail
module add gcc/${GCC_VERSION}
module load python/${PYTHON_VERSION}

echo "REPO_DIR is "
echo $REPO_DIR
echo "SRC_DIR is "
echo $SRC_DIR
echo "WORKSPACE is "
echo $WORKSPACE
echo "SOFT_DIR is"
echo $SOFT_DIR

mkdir -p $WORKSPACE
mkdir -p $SRC_DIR
mkdir -p $SOFT_DIR

#  Download the source file

if [[ ! -e $SRC_DIR/$SOURCE_FILE ]] ; then
  echo "seems like this is the first build - Let's get the $SOURCE_FILE from $SOURCE_REPO and unarchive to $WORKSPACE"
  mkdir -p $SRC_DIR
  wget $SOURCE_REPO/$SOURCE_FILE -O $SRC_DIR/$SOURCE_FILE
else
  echo "continuing from previous builds, using source at " $SRC_DIR/$SOURCE_FILE
fi

tar -xvz  --keep-newer-files -f $SRC_DIR/$SOURCE_FILE -C $WORKSPACE
cd $WORKSPACE/$NAME-$VERSION

echo "Configuring the build"
python setup.py build
