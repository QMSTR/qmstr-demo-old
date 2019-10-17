
function setup_git_src() {
    repo_url=$1
    branch=$2
    dir=$3

    git clone -b "${branch}" --single-branch "${repo_url}" "${dir}" || (cd "${dir}"; git fetch; git reset --hard "${branch}")
    (cd "${dir}" && git clean -ffxd)
}

function hashthis() {
  sha1sum $1 | awk '{ print $1 }'
}

# getOldestHash() uses the path and the timestamp of a node
# and returns the hash of the oldest node
function getOldestHash() {
	TIMESTAMP=`qmstrctl describe file:path:$1 | grep $1 | awk -F'[ ,]' '/Timestamp/{print $12}' | sort -n | head -1`
    TIMESTAMP="/${TIMESTAMP}/"
	qmstrctl describe file:path:$1 | grep $1 | awk -F'[ ,]' ''$TIMESTAMP'{print $9}' | head -1
}

function getUid() {
	qmstrctl describe file:hash:$1 | grep $2 | awk '/Uid/{print $NF}'
}
