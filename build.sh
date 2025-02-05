 
#!/bin/bash

for addon in "$@"; do
    if [ -z ${TRAVIS_COMMIT_RANGE} ] || git diff --name-only ${TRAVIS_COMMIT_RANGE} | grep -v README.md | grep -q ${addon}; then
		archs=$(jq -r '.arch // ["armhf", "armv7", "amd64", "aarch64", "i386"] | .[]' ${addon}/config.json)
		for arch in $archs; do
			docker run --rm --privileged -v /var/run/docker.sock:/var/run/docker.sock -v ~/.docker:/root/.docker -v $(pwd)/${addon}:/data homeassistant/amd64-builder --${arch} --docker-hub-check --target /data
		done
    else
		echo "No change in commit range ${TRAVIS_COMMIT_RANGE}"
    fi
done
