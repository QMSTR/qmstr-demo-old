
folderName = 'demojobs'

folder(folderName) {
    description('Demo Jobs')
}

demosPath = new File("/demos")
demosPath.eachFile {
    def file = new File(it + "Jenkinsfile")
    if (file.exists()) {
        job = freeStyleJob("$folderName/" + it )

        job.with {
            steps {
                shell 'echo file exists'
                shell 'ls'
                shell '/Jenkinsfile'
            }
        }
    }
}

