#!/bin/sh

WHOAMI=`python -c 'import os, sys; print os.path.realpath(sys.argv[1])' $0`

WHEREAMI=`dirname $WHOAMI`
TOOLS=`dirname $WHEREAMI`

PROJECT=$1
PROJET_NAME=`basename ${PROJECT}`

echo "cloning dependencies"
echo "------------------------------";

git clone https://github.com/straup/flamework.git ${PROJECT}/

mkdir -p ${PROJECT}/apache

echo "*~" >> ${PROJECT}/.gitignore
echo "*.conf" >> ${PROJECT}/apache/.gitignore
rm -rf ${PROJECT}/.git
rm -f ${PROJECT}/.gitattributes

echo "setting up README files"
echo "------------------------------";

mv ${PROJECT}/README.md	${PROJECT}/README.FLAMEWORK.md

echo ${PROJECT_NAME} > ${PROJECT}/README.md
echo "--" >> ${PROJECT}/README.md

echo "removing unnecessary files"
echo "------------------------------";

rm -rf ${PROJECT}/www/cron
rm -rf ${PROJECT}/docs
rm -rf ${PROJECT}/tests

# TODO: figure out if sudo is necessary
# sudo chown -R www-data ${PROJECT}/www/templates_c

echo "setting up apache files"
echo "------------------------------";

cp ${TOOLS}/apache/example.conf ${PROJECT}/apache/${PROJECT_NAME}.conf.example
cp ${TOOLS}/apache/example.conf ${PROJECT}/apache/README.md

echo "setting up .htaccess files"
echo "------------------------------";

cp ${TOOLS}/apache/.htaccess-deny ${PROJECT}/apache/.htaccess
cp ${TOOLS}/apache/.htaccess-deny ${PROJECT}/schema/.htaccess
cp ${TOOLS}/apache/.htaccess-deny ${PROJECT}/bin/.htaccess
cp ${TOOLS}/apache/.htaccess-noindexes ${PROJECT}/.htaccess

echo "setting up (application) config files"
echo "------------------------------";

cp ${PROJECT}/www/include/config.php.example ${PROJECT}/www/include/config.php
echo "*~" >> ${PROJECT}/www/.gitignore

${TOOLS}/bin/configure-secrets.sh ${PROJECT}

echo "all done";
echo "------------------------------";
echo ""
