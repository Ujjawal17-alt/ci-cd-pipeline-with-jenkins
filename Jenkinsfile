pipeline {
  agent any

  environment {
    // full image name will be set in the build stage (namespace/repo)
    IMAGE_NAME = 'instantprachi/myapp'
    REGISTRY = '' // Docker Hub (default)
  }

  stages {
    stage('Clone Repository') {
      steps {
        // checkout the repository you provided
        git url: 'https://github.com/Ujjawal17-alt/ci-cd-pipeline-with-jenkins', branch: 'main'
      }
    }

    stage('Build Docker Image') {
      steps {
        script {
          // create a traceable tag using BUILD_NUMBER and short commit
          def commit = env.GIT_COMMIT ?: sh(script: 'git rev-parse --short=7 HEAD', returnStdout: true).trim()
          def tag = "${env.BUILD_NUMBER}-${commit.take(7)}"
          def fullImage = "${env.IMAGE_NAME}:${tag}"

          echo "Building ${fullImage}"
          sh "docker build -t ${fullImage} ."

          // expose for later stages
          env.FULL_IMAGE = fullImage
        }
      }
    }

    stage('Push to Docker Hub') {
      steps {
        // use Jenkins credentials binding for username/password safely
        withCredentials([usernamePassword(credentialsId: 'dockerhub-logintask', usernameVariable: 'DOCKERHUB_USR', passwordVariable: 'DOCKERHUB_PSW')]) {
          sh 'echo $DOCKERHUB_PSW | docker login -u $DOCKERHUB_USR --password-stdin'
          sh 'docker push $FULL_IMAGE'
          sh 'docker logout'
        }
      }
    }
  }

  post {
    success {
      echo "Successfully pushed ${env.FULL_IMAGE}"
    }
    failure {
      echo 'Pipeline failed'
    }
  }
}

      stages {
        stage('Checkout') {
          steps {
            echo "Checking out ${params.GIT_URL} @ ${params.GIT_BRANCH}"
            // perform a Git checkout so env.GIT_COMMIT is populated when possible
            git branch: params.GIT_BRANCH, url: params.GIT_URL
          }
        }

        stage('Build Docker Image') {
          steps {
            script {
              // Prefer Jenkins-provided GIT_COMMIT; fallback to git command for short SHA
              def commit = env.GIT_COMMIT
              if (!commit) {
                commit = sh(script: 'git rev-parse --verify HEAD', returnStdout: true).trim()
              }
              def shortSha = (commit ?: 'unknown').take(7)

              def tag = "${params.DOCKER_TAG}-${env.BUILD_NUMBER}-${shortSha}"
              def fullImage = "${params.IMAGE_NAME}:${tag}"
              echo "Building image ${fullImage}"
              // Build the image using Docker Pipeline
              docker.build(fullImage)

              // store the built image info for later stages
              env.BUILT_IMAGE = fullImage
              env.IMAGE_TAG = tag
            }
          }
        }

        stage('Push to Docker Hub') {
          steps {
            script {
              docker.withRegistry(env.REGISTRY, env.DOCKERHUB_CREDENTIALS) {
                def fullImage = env.BUILT_IMAGE
                echo "Pushing ${fullImage} to Docker Hub"
                // push the versioned build tag
                docker.image(fullImage).push()

                // also tag and push 'latest' so the image namespace has a stable tag
                try {
                  sh "docker tag ${fullImage} ${params.IMAGE_NAME}:latest"
                  docker.image("${params.IMAGE_NAME}:latest").push()
                } catch (err) {
                  echo "Could not tag or push 'latest': ${err}"
                }
              }
            }
          }
        }
      }

      post {
        success {
          echo "Image pushed: ${env.BUILT_IMAGE}"
        }
        failure {
          echo "Pipeline failed"
        }
      }
    }

