pipeline {

    // Run on any available agent (your EC2 Jenkins server)
    agent any

    // Environment variables available throughout pipeline
    environment {
        VENV_DIR = "venv"
        PORT = "5000"
        APP_ENV = "production"
    }

    stages {

        // --------------------------------
        // 1️⃣ Checkout Code from GitHub
        // --------------------------------
        stage('Checkout') {
            steps {
                echo "Checking out source code..."
                checkout scm
            }
        }

        // --------------------------------
        // 2️⃣ Setup Python Environment
        // --------------------------------
        stage('Setup Environment') {
            steps {
                echo "Creating virtual environment and installing dependencies..."

                sh '''
                    # Show Python version
                    python3 --version

                    # Remove old venv if exists
                    rm -rf $VENV_DIR

                    # Create new virtual environment
                    python3 -m venv $VENV_DIR

                    # Upgrade pip inside virtual environment
                    $VENV_DIR/bin/pip install --upgrade pip

                    # Install project dependencies
                    $VENV_DIR/bin/pip install -r requirements.txt
                '''
            }
        }

        // --------------------------------
        // 3️⃣ Run Automated Tests
        // --------------------------------
        stage('Run Tests') {
            steps {
                echo "Running pytest..."

                sh '''
                    $VENV_DIR/bin/pytest
                '''
            }
        }

        // --------------------------------
        // 4️⃣ Deploy Application (Only main branch)
        // --------------------------------
        stage('Deploy') {
            steps {
                echo "Deploying Flask app using Gunicorn..."

                sh '''
                    pkill -f gunicorn || true

                    # Start gunicorn fully detached from Jenkins
                    nohup setsid $VENV_DIR/bin/gunicorn -w 2 -b 0.0.0.0:$PORT app:app > gunicorn.log 2>&1 < /dev/null &
                '''
            }
        }

    }

    // --------------------------------
    // Post Actions
    // --------------------------------
    post {

        success {
            echo "Build SUCCESS - Application deployed successfully!"
        }

        failure {
            echo "Build FAILED - Check console output."
        }

        always {
            echo "Pipeline execution completed."
        }
    }
}
