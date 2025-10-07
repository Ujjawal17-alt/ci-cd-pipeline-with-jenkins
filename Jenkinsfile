pipeline {
  agent any

  environment {
    IMAGE_NAME = 'ujjawalcloud/myapp'
    // Jenkins credential ID for Docker Hub (username/password or token)
    DOCKERHUB_CREDENTIALS = 'dockerhub-logintask'
  }

  stages {
    stage('Checkout') {
      steps {
        git url: 'https://github.com/Ujjawal17-alt/ci-cd-pipeline-with-jenkins', branch: 'main'
      }
    }

    stage('Build') {
      steps {
        script {
          def commit = env.GIT_COMMIT ?: sh(script: 'git rev-parse --verify HEAD', returnStdout: true).trim()
          def shortSha = (commit ?: 'unknown')[0..6]
          def tag = "${env.BUILD_NUMBER}-${shortSha}"
          env.FULL_IMAGE = "${env.IMAGE_NAME}:${tag}"

          echo "Building ${env.FULL_IMAGE}"
          sh "docker build -t ${env.FULL_IMAGE} ."
        }
      }
    }

    stage('Push') {
      steps {
        script {
          withCredentials([usernamePassword(credentialsId: env.DOCKERHUB_CREDENTIALS, usernameVariable: 'DOCKER_HUB_USER', passwordVariable: 'DOCKER_HUB_PSW')]) {
            sh 'echo $DOCKER_HUB_PSW | docker login -u $DOCKER_HUB_USER --password-stdin'
            sh "docker push ${env.FULL_IMAGE}"
            sh "docker tag ${env.FULL_IMAGE} ${env.IMAGE_NAME}:latest || true"
            sh "docker push ${env.IMAGE_NAME}:latest || true"
            sh 'docker logout'
          }
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
