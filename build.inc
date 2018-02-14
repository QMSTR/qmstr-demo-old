function run_qmstr_prod() {
    docker run --rm -d -p 50051:50051 -v $(pwd):/buildroot qmstr/master
}

function run_qmstr_dev() {
    if [ -z "$QMSTR_SRC" ]; then
        echo "Please set QMSTR_SRC to point to your qmstr source directory."
        exit 2
    fi
    docker run --rm -d -p 50051:50051 -p 8000:8000 -p 8080:8080 -v "${QMSTR_SRC}":/go/src/github.com/QMSTR/qmstr -v $(pwd):/buildroot qmstr/dev

}

function init() {
    if [ -z "$QMSTR_HOME" ]; then
        echo "Please set QMSTR_HOME. See github.com/QMSTR/qmstr-demo."
        exit 1
    fi

    export PATH=$QMSTR_HOME/bin:$PATH
}

function run_qmstr_master() {
    if [ -z "$QMSTR_DEBUG" ]; then
        run_qmstr_prod
    else
        run_qmstr_dev
    fi
}

function setup_git_src() {
    repo_url=$1
    branch=$2
    dir=$3

    git clone -b "${branch}" --single-branch "${repo_url}" "${dir}" || (cd "${dir}"; git fetch; git reset --hard origin/"${branch}")
}
