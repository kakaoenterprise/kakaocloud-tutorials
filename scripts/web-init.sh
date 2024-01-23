#!/bin/bash

cd ~/
git clone https://github.com/kakaoenterprise/kic-library-react
cd kic-library-react
bash install-requirements.sh
cd client

sudo mv /tmp/web-env.sh ./

bash web-build.sh
bash start-web.sh