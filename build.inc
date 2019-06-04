
function setup_git_src() {
    repo_url=$1
    branch=$2
    dir=$3

    git clone -b "${branch}" --single-branch "${repo_url}" "${dir}" || (cd "${dir}"; git fetch; git reset --hard "${branch}")
    (cd "${dir}" && git clean -ffxd)
}
