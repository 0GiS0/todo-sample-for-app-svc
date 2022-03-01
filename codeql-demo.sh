# Download CodeQL for mac with cURL
curl -L https://github.com/github/codeql-cli-binaries/releases/download/v2.8.2/codeql-osx64.zip -o codeql-osx64.zip

# Create a folder for CodeQL
mkdir $HOME/codeql-home

# Unzip the file in $HOME/codeql-home folder
unzip codeql-osx64.zip -d $HOME/codeql-home && rm codeql-osx64.zip

# Download queries and add them to the CodeQL home folder
cd $HOME/codeql-home
git clone --recursive https://github.com/github/codeql.git codeql-repo

# Add the CodeQL home folder to the PATH
export PATH=$PATH:$HOME/codeql-home/codeql

# Check the configuration
codeql resolve languages
codeql resolve qlpacks

# Create a database of my code
codeql database create codeqldb --language=csharp

# Run codeql-suites for csharp

CODEQL_SUITES_PATH=$HOME/codeql-home/codeql-repo/csharp/ql/src/codeql-suites
RESULTS_FOLDER=codeql-results

mkdir -p $RESULTS_FOLDER

# Code Scanning suite: Queries run by default in CodeQL code scanning on GitHub.
codeql database analyze codeqldb $CODEQL_SUITES_PATH/csharp-code-scanning.qls \
--format=sarif-latest \
--output=$RESULTS_FOLDER/csharp-code-scanning.sarif 

# Security extended suite: Queries of lower severity and precision than the default queries
codeql database analyze codeqldb $CODEQL_SUITES_PATH/csharp-security-extended.qls \
--format=sarif-latest \
--output=$RESULTS_FOLDER/csharp-security-extended.sarif

# Security and quality suite: Queries of lower severity and precision than the default queries
codeql database analyze codeqldb $CODEQL_SUITES_PATH/csharp-security-and-quality.qls \
--format=sarif-latest \
--output=$RESULTS_FOLDER/csharp-security-and-quality.sarif 