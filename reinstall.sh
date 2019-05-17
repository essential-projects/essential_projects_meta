# remove "node_modules"
echo "Purging node_modules..."
find . -name "node_modules" -exec rm -rf '{}' +
echo "Done. Starting setup..."

# install all necessary dependencies
npm install --no-package-lock

# If npm install (or minstall) fails, stop any further execution.
# This is advisable since a failed npm install may lead to failures in the
# building process.
if [[ "$?" -ne "0" ]]; then
  printf "\e[1;31mError while executing npm install!\e[0m\n";
  exit 1;
fi

# build all packages
meta exec "npm run build" --exclude essential_projects_meta,iam_contracts,eslint-config

function install_and_build_package {
  cd typescript
  npm install --no-package-lock
  cd ..

  if [ -x "$(command -v dotnet)" ]; then
    cd dotnet/src
    dotnet restore && dotnet build
    cd ../..
  else
    echo ""
    echo "WARNING: skipping dotnet (since it is not installed)."
    echo ""
  fi
}

echo "-------------------------------------------------"
echo "Installing IAM Contracts"
echo "-------------------------------------------------"
cd iam_contracts
install_and_build_package
cd ..

echo "done"
