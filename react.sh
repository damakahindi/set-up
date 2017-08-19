function printHelp () {
  echo "Usage: "
  echo "  react.sh -m react[-r <repo>]"
  echo "  react.sh -h|--help "
  echo "    -m <mode> - one of 'react-redux'"
  echo "      - 'react' - sets up a react-redux application"
  echo "    -r <repo> - use existing"
}

# Ask user for confirmation to proceed
function askProceed () {
  read -p "Continue (y/n)? " ans
  case "$ans" in
    y|Y )
      echo "proceeding ..."
    ;;
    n|N )
      echo "exiting..."
      exit 1
    ;;
    * )
      echo "invalid response"
      askProceed
    ;;
  esac
}

# Generate needed react App
function reactUp () {
  echo "Creating React App"
  cd /Users/estherdamakahindi/projects/Learning/MyProjects

  if [ -z "$GITHUB_REPO" ] ; then
    echo " YOU DID NOT INITIALISE A REPO"
    exit
  else
    GIT_CLONE_URL=$MY_GITHUB_URL$GITHUB_REPO$DOTGIT
    echo "$GIT_CLONE_URL"
    git clone $GIT_CLONE_URL
    cd $GITHUB_REPO
    git checkout -b develop
  fi
  echo "Doing yarn Init fill in the required"
  yarn init --yes
  yarn add react react-dom webpack html-webpack-plugin webpack-dev-server path eslint extract-text-webpack-plugin style-loader css-loader jest react-addons-test-utils react-bootstrap bootstrap@3 enzyme
  yarn add --dev babel-loader babel-core babel-preset-es2015 babel-preset-react babel-jest babel-polyfill

  # Copy webpack.config.js
  cp -r /Users/estherdamakahindi/projects/Learning/MyProjects/set-up/webpack.config.js ./
  # Copy .babelrc the  files to the right directory
  cp -r /Users/estherdamakahindi/projects/Learning/MyProjects/set-up/.babelrc ./
  # Copy .eslintrc.json
  ./node_modules/.bin/eslint --init

  mkdir src && cd src/
  # Copy index.html into src
  cp -r /Users/estherdamakahindi/projects/Learning/MyProjects/set-up/index.html ./
  
  # Make index.js
  touch index.js store.js
  mkdir components reducers actions containers
  cd components/ && touch App.jsx && cd ..
  cd reducers && touch index.js && cd ..
  cd actions && touch actionCreators.js constants.js && cd ..
  mkdir tests/ && cd tests && touch App.test.js

  # Copy the test files
      "scripts": {
    },

  echo "Edit your packege.json, index.js, App.js and App.test.js"
  echo 
  echo "##########################################################"
  echo "##### After eding that you are all set up. Happy Hacking #########" 
  echo "##########################################################"

}

OS_ARCH=$(echo "$(uname -s|tr '[:upper:]' '[:lower:]'|sed 's/mingw64_nt.*/windows/')-$(uname -m | sed 's/x86_64/amd64/g')" | awk '{print tolower($0)}')
# channel name defaults to "mychannel"
GITHUB_REPO=""
GIT_CLONE_URL=""
MY_GITHUB_URL="git@github.com:damakahindi/"
DOTGIT=".git"

# Parse commandline args
while getopts "h?m:r:" opt; do
  case "$opt" in
    h|\?)
      printHelp
      exit 0
    ;;
    m)  MODE=$OPTARG
    ;;
    r)  GITHUB_REPO=$OPTARG
    ;;
  esac
done

# Determine whether starting, stopping, restarting or generating for announce
if [ "$MODE" == "react" ]; then
  EXPMODE="React-Redux"
else
  printHelp
  exit 1
fi

# Announce what was requested
echo "${EXPMODE} projest being initialised with '${GITHUB_REPO}' Github repo?"

# ask for confirmation to proceed
askProceed

#Create the network using docker compose
if [ "${MODE}" == "react" ]; then
  reactUp
  exit 1
else
  printHelp
  exit 1
fi