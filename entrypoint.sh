#!/usr/bin/env sh

set -e

NC='\e[0m'
BOLD='\e[1m'
UNDERLINE='\e[4m'
BRED='\e[1;4;31m'
IRED='\e[3;31m'
BGREEN='\e[1;32m'


if [ -z "${INPUT_GITHUBTOKEN}" ]; then
  echo -e "${BRED}Error:\n${NC} ${IRED}Missing Github Access Token${NC}"
  exit 1
fi

if [ "${INPUT_REPO}" ]; then
  REPO=${INPUT_REPO}
else
  REPO=${GITHUB_REPOSITORY}
fi

REPO_URL="https://x-access-token:${INPUT_GITHUBTOKEN}@github.com/${REPO}.git"

echo -e "${UNDERLINE}Resume${NC}"
echo -e "${BOLD}REPO:${NC} ${REPO}"
echo -e "${BOLD}BRANCH:${NC} ${INPUT_BRANCH}"
[ -n "${INPUT_CNAME}" ] && echo -e "${BOLD}CNAME:${NC} ${INPUT_CNAME}"

echo -e "\n${BOLD}Setting up Git${NC}..."
git config --global user.name "${GITHUB_ACTOR}"
git config --global user.email "${GITHUB_ACTOR}@users.noreply.github.com"
echo "machine github.com login ${GITHUB_ACTOR} password ${INPUT_GITHUBTOKEN}" > ~/.netrc

echo -e "\nBuilding.."
git clone --depth=1 --single-branch --branch "${INPUT_BRANCH}" "${REPO_URL}" /tmp/build

rm -rf /tmp/build/*

cobalt build

cp -a build/* /tmp/build

cd /tmp/build

[ -n "${INPUT_CNAME}" ] && echo "${INPUT_CNAME}" > CNAME
echo -e " \b${BGREEN}[OK]${NC}"

echo -e "\n\nPuching..."
git add -A && git commit --allow-empty -am "Publishing site at $(date -u)"
git push --force
echo -e " \b${BGREEN}[OK]${NC}"
