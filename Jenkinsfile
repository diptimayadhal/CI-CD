pipeline {
    agent any   // Run this pipeline on any available Jenkins agent (in our case, the EC2 server)

    stages {

        stage('Checkout') {
            steps {
                echo 'Checking out source code...'

                // This pulls the latest code from GitHub repository
                // 'scm' refers to the repo configured in Pipeline job
                checkout scm
            }
        }

        stage('Setup Python Environment') {
            steps {
                echo 'Setting up virtual environment...'

                sh '''
                    # Show Python version to confirm environment
                    python3 --version

                    # Create virtual environment named "venv"
                    # This isolates project dependencies
                    python3 -m venv venv

                    # Upgrade pip inside the virtual environment
                    # We use direct path instead of "source"
                    # Because Jenkins runs /bin/sh, not bash
                    ./venv/bin/pip install --upgrade pip

                    # Install project dependencies from requirements.txt
                    ./venv/bin/pip install -r requirements.txt
                '''
            }
        }

        stage('Run Tests') {
            steps {
                echo 'Running pytest...'

                sh '''
                    # Run pytest using virtual environment python
                    # This ensures correct dependencies are used
                    ./venv/bin/pytest
                '''
            }
        }

    }

    post {
        success {
            // This runs only if all stages succeed
            echo 'Build SUCCESS'
        }
        failure {
            // This runs if any stage fails
            echo 'Build FAILED'
        }
    }
}
