SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

if [[ "${EUID}" == 0 ]] ; then
   echo "Do not run this as root."
   exit 1
fi

until [[ $OPTION == '0' ]]; do
  echo 'what would you like to do?
  [0] quit
  [1] create a new cluster
  [2] add a node to a cluster
  [3] reset an old cluster'
  read OPTION

  if [[ $OPTION == '1' ]]; then
    bash $SCRIPT_DIR/newcluster.sh
  fi

  if [[ $OPTION == '2' ]]; then
    bash $SCRIPT_DIR/addnode.sh
  fi

  if [[ $OPTION == '3' ]]; then
    bash $SCRIPT_DIR/resetcluster.sh
  fi
done
