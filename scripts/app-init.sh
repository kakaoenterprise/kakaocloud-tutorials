#!/bin/bash

cd ~/
git clone https://github.com/kakaoenterprise/kic-library-react
cd kic-library-react
bash install-requirements.sh

sudo mv /tmp/app-env.sh ./

bash app-build.sh
bash start-app.sh