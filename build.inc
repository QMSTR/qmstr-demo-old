function run_qmstr_prod() {
    echo "Running qmstr-master container"
    docker run --rm -d -p 50051:50051 -v $(pwd):/buildroot qmstr/master
}

function run_qmstr_dev() {
    if [ -z "$GOPATH" ]; then
        echo "Please set your GOPATH."
        exit 2
    fi
    echo "Running qmstr-master development container"
    docker run --name qmstr-demo-master --rm -d -p 50051:50051 -p 8000:8000 -p 8080:8080 ${QMSTR_DEV:+"-p${QMSTR_DEV}:2345"} ${QMSTR_DEV:+"-eQMSTR_DEV=${QMSTR_DEV}"} ${QMSTR_DEV:+--security-opt seccomp=unconfined} -v "${GOPATH}"/src:/go/src -v $(pwd):/buildroot qmstr/dev

}

function init() {
    if [ -z "$QMSTR_HOME" ]; then
        echo "Please set QMSTR_HOME. See github.com/QMSTR/qmstr-demo."
        exit 1
    fi

    export PATH=$QMSTR_HOME/bin:$PATH
}

function run_qmstr_master() {
    if [ -n ${QMSTR_DEV+x} ]; then
        echo "qmstr-master development container selected"
        run_qmstr_dev
    else
        run_qmstr_prod
    fi
}

function setup_git_src() {
    repo_url=$1
    branch=$2
    dir=$3

    git clone -b "${branch}" --single-branch "${repo_url}" "${dir}" || (cd "${dir}"; git fetch; git reset --hard origin/"${branch}")
}
