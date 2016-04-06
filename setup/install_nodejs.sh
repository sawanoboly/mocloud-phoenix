#!/bin/bash
set -e

git clone --depth 1 https://github.com/isaacs/nave.git ${NAVE_DIR}
/opt/nave/bin/nave install ${NAVE_NODEVER}
/opt/nave/bin/nave usemain ${NAVE_NODEVER}
/usr/local/bin/npm install -g brunch
