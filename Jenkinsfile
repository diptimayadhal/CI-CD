pipeline {

    // Agent tells Jenkins where to run this pipeline
    // "any" means run on any available executor (your EC2 server)
    agent any

    // Environment variables available in all stages
    environment {
        APP_ENV = "production"
        VENV_DIR = "venv"
        PORT = "5000"
    }

    stages {

        // -------------------------------
        // Stage 1: Checkout Source Code
        // -------------------------------
        stage('Checkout') {
            steps {
                echo "Checking out source code from GitHub..."
                // This pulls the latest code from the repository
                checkout scm
            }
        }

        // --------------------------------------
        // Stage 2: Setup Python Environment
        // --------------------------------------
        stage('Setup Environment') {
            steps {
                echo "Creating virtual environment and installing dependencies..."

                sh '''
                    # Show Python version
                    python3 --version

                    # Remove old virtual environment if exists
                    rm -rf $VENV_DIR

                    # Create new virtual environment
                    python3 -m venv $VENV_DIR

                    # Activate virtual environment
                    source $VENV_DIR/bin/activate

                    # Upgrade pip
                    pip install --upgrade pip

                    # Install project dependencies
                    pip install -r requirements.txt
                '''
            }
        }

        // -------------------------------
        // Stage 3: Run Automated Tests
        // -------------------------------
        stage('Run Tests') {
            steps {
                echo "Running pytest..."

                sh '''
                    source $VENV_DIR/bin/activate

                    # Run test cases
                    pytest
                '''
            }
        }

        // -------------------------------
        // Stage 4: Deploy Application
        // -------------------------------
        stage('Deploy') {

            // Only deploy when branch is main
            when {
                branch 'main'
            }

            steps {
                echo "Deploying Flask application using Gunicorn..."

                sh '''
                    source $VENV_DIR/bin/activate

                    # Stop old Gunicorn process if running
                    pkill -f gunicorn || true

                    # Start Gunicorn in background
                    # -w 2 = 2 worker processes
                    # -b = bind to 0.0.0.0:5000
                    nohup gunicorn -w 2 -b 0.0.0.0:$PORT app:app > gunicorn.log 2>&1 &
                '''
            }
        }
    }

    // --------------------------------------
    // Post Actions (After Pipeline Ends)
    // --------------------------------------
    post {

        success {
            echo "Build SUCCESS - Application deployed successfully!"
        }

        failure {
            echo "Build FAILED - Check console logs."
        }

        always {
            echo "Pipeline execution completed."
        }
    }
}
