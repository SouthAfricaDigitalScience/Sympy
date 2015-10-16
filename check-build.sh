#!/bin/bash

. /usr/share/modules/init/bash
module load ci
module load python/$PYTHON_VERSION

echo "Running python check"
cd $WORKSPACE/$NAME-$VERSION
python setup.py check

echo $?
if [ $? != 0 ] ; then
  exit 1
fi


echo "Running python install"
python setup.py install --prefix=$SOFT_DIR

mkdir -p modules
(
cat <<MODULE_FILE
#%Module1.0
## $NAME modulefile
##
proc ModulesHelp { } {
   puts stderr "\tAdds $NAME $VERSION to your environment"
}
module-whatis   "$NAME $VERSION."
setenv       SYMPY_VERSION       $VERSION
setenv       SYMPY_DIR           /apprepo/$::env(SITE)/$::env(OS)/$::env(ARCH)/$NAME/$VERSION

prepend-path 	  PATH            $::env(SYMPY_DIR)/bin
prepend-path    LD_LIBRARY_PATH $::env(SYMPY_DIR)/lib
MODULE_FILE
) > modules/$VERSION
mkdir -p $LIBRARIES_MODULES/$NAME
cp modules/$VERSION $LIBRARIES_MODULES/$NAME/$VERSION

# Testing module
module avail
module list
