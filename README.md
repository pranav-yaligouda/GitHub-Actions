# 🚀 Express.js CI/CD Pipeline with GitHub Actions

## 📋 Project Overview

This project demonstrates a complete **CI/CD pipeline** for a Node.js Express application using **GitHub Actions**, **Docker**, and **Render** deployment. The project showcases modern DevOps practices with automated testing, building, and deployment.

## 🎯 What This Project Accomplishes

- ✅ **Express.js API** with proper environment configuration
- ✅ **Dockerized Application** with security best practices
- ✅ **GitHub Actions CI/CD** with comprehensive testing
- ✅ **Automated Docker Hub** image publishing
- ✅ **Automatic Render Deployment** on successful builds
- ✅ **Local Testing Setup** with act tool

## 🏗️ Project Structure

```
GitHub-Actions/
├── .github/
│   └── workflows/
│       └── main.yaml              # CI/CD pipeline configuration
├── config/
│   └── envconfig.js              # Environment configuration
├── app.js                        # Main Express application
├── package.json                  # Node.js dependencies
├── Dockerfile                    # Docker container definition
├── .env                         # Environment variables
├── .secrets                     # Local secrets for testing
├── .dockerignore               # Docker ignore file
└── README.md                   # This file
```

## 🔄 Development Timeline (Commit History)

### Phase 1: Project Initialization
- **Commit 1**: `Initialized node package`
  - Set up Node.js project structure
  - Created basic package.json

### Phase 2: Express Application Setup
- **Commit 2**: `installed express framework and .gitignore node_modules`
  - Added Express.js framework
  - Configured Git ignore patterns

### Phase 3: Modern ES Modules & Configuration
- **Commit 3**: `changed module type to use es module installed express dotenv dependencies`
  - Migrated to ES6 modules (`"type": "module"`)
  - Added dotenv for environment management
  - Created centralized config system
  - Implemented environment variable best practices

### Phase 4: Application & Containerization
- **Commit 4**: `Created new simple express server with simple message output for home route / and created docker file for the app`
  - Built Express server with basic route
  - Created Dockerfile with security best practices
  - Implemented non-root user containers

### Phase 5: CI/CD Pipeline Implementation
- **Commit 5**: `Created new .yaml for the git actions definition with docker build test and push to dockerhub and the local setup of chock act for local actions testing`
  - Implemented complete GitHub Actions workflow
  - Added Docker build, test, and push automation
  - Set up local testing with Chocolatey and act tool
  - Configured Render deployment integration

## 🛠️ Technologies Used

| Technology | Purpose | Implementation |
|------------|---------|----------------|
| **Node.js** | Runtime Environment | Express.js application |
| **Express.js** | Web Framework | Simple REST API |
| **Docker** | Containerization | Multi-stage builds, security hardening |
| **GitHub Actions** | CI/CD Pipeline | Automated testing and deployment |
| **Docker Hub** | Container Registry | Image storage and distribution |
| **Render** | Cloud Platform | Production deployment |
| **act** | Local Testing | GitHub Actions local simulation |

## 🔧 Local Development Setup

### Prerequisites
- Node.js 18+ 
- Docker Desktop
- Git

### Installation Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/pranav-yaligouda/GitHub-Actions.git
   cd GitHub-Actions
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Configure environment**
   ```bash
   # Copy .env.example to .env (if exists) or create .env
   NODE_ENV=development
   PORT=8080
   ```

4. **Run locally**
   ```bash
   # Development mode
   npm run dev

   # Production mode
   npm start
   ```

5. **Test with Docker**
   ```bash
   docker build -t express-app .
   docker run -p 8080:8080 -e PORT=8080 express-app
   ```

## 🧪 Local CI/CD Testing Setup

### Install Testing Tools

```powershell
# Install Chocolatey (Windows Package Manager)
Set-ExecutionPolicy Bypass -Scope Process -Force
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Install act (GitHub Actions local runner)
choco install act-cli
# OR direct download
Invoke-WebRequest -Uri "https://github.com/nektos/act/releases/latest/download/act_Windows_x86_64.zip" -OutFile "act.zip"
```

### Configure Local Secrets

```bash
# Create .secrets file
DOCKER_USERNAME=your-docker-username
DOCKER_PASSWORD=your-docker-token
RENDER_DEPLOY_HOOK=https://api.render.com/deploy/srv-xxx?key=xxx
```

### Run Local Tests

```bash
# Test the full workflow
act push --secret-file .secrets

# Test pull request workflow (no deployment)
act pull_request --secret-file .secrets

# Verbose output for debugging
act push --secret-file .secrets -v
```

## 🚀 CI/CD Pipeline Details

### Workflow: `.github/workflows/main.yaml`

The pipeline consists of the following stages:

#### 1. **🔍 Code Checkout**
- Fetches latest code from repository
- Sets up workspace environment

#### 2. **🔨 Docker Build & Test**
```yaml
- name: Build Docker image
  run: docker build -t pranavyaligouda/express-app:test .

- name: Test Docker container
  run: |
    docker run -d -p 8080:8080 -e PORT=8080 --name test-app pranavyaligouda/express-app:test
    sleep 15
    curl -f http://localhost:8080 --max-time 10
```

#### 3. **🏭 Multi-Platform Build & Push**
```yaml
- name: Build and Push Docker image
  uses: docker/build-push-action@v5
  with:
    platforms: linux/amd64,linux/arm64
    push: true
    tags: |
      pranavyaligouda/express-app:latest
      pranavyaligouda/express-app:${{ github.sha }}
```

#### 4. **🌐 Production Deployment**
```yaml
- name: Deploy to Render
  run: |
    response=$(curl -s -o /dev/null -w "%{http_code}" -X POST ${{ secrets.RENDER_DEPLOY_HOOK }})
    if [ "$response" -eq 200 ]; then
      echo "Deployment triggered successfully"
    fi
```

### Trigger Conditions

| Event | Behavior |
|-------|----------|
| **Push to main** | Full pipeline: Build → Test → Push → Deploy |
| **Pull Request** | Test only: Build → Test (no push/deploy) |

## 🐳 Docker Configuration

### Dockerfile Highlights

```dockerfile
FROM node:22-alpine                 # Lightweight base image
RUN addgroup app && adduser -S -G app app  # Security: non-root user
WORKDIR /app
RUN chown -R app:app .             # Proper ownership
USER app                           # Switch to non-root
COPY package*.json ./
RUN npm ci --omit=dev              # Production dependencies only
COPY . .
EXPOSE 8080
CMD ["npm","start"]
```

### Security Features
- ✅ Non-root user execution
- ✅ Minimal attack surface (Alpine Linux)
- ✅ Production-only dependencies
- ✅ Proper file ownership

## 📊 Monitoring & Verification

### Health Checks
The pipeline includes health checks:

```bash
# Container health verification
curl -f http://localhost:8080 --max-time 10

# Container logs on failure
docker logs test-app
```

### Deployment Verification
- **Docker Hub**: Check image push at [pranavyaligouda/express-app](https://hub.docker.com/r/pranavyaligouda/express-app)
- **Render**: Monitor deployment status in Render dashboard
- **Production**: Test live endpoint after deployment

## 🔑 Required Secrets

Configure these secrets in your GitHub repository:

| Secret Name | Purpose | Example |
|-------------|---------|---------|
| `DOCKER_USERNAME` | Docker Hub login | `pranavyaligouda` |
| `DOCKER_PASSWORD` | Docker Hub token/password | `dckr_pat_xxxxx` |
| `RENDER_DEPLOY_HOOK` | Render deployment webhook | `https://api.render.com/deploy/srv-xxx?key=xxx` |

## 🎯 Benefits Achieved

### 🚀 **Automation**
- Zero-touch deployment from code commit to production
- Automatic testing prevents broken deployments
- Multi-platform Docker image support

### 🔒 **Security**
- Secrets management with GitHub Secrets
- Non-root Docker containers
- Production-only dependency installation

### 🧪 **Quality Assurance**
- Container health checks before deployment
- Local testing capabilities with act
- Failed deployments automatically cancelled

### ⚡ **Performance**
- Docker layer caching for faster builds
- Multi-platform support (AMD64/ARM64)
- GitHub Actions caching optimization

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Test locally with `act push --secret-file .secrets`
4. Commit changes (`git commit -m 'Add amazing feature'`)
5. Push to branch (`git push origin feature/amazing-feature`)
6. Open a Pull Request

## 📝 License

This project is licensed under the ISC License.

## 👨‍💻 Author

**Pranav Yaligouda**
- GitHub: [@pranav-yaligouda](https://github.com/pranav-yaligouda)

---

## 🎉 Project Accomplishments Summary

✅ **Complete CI/CD Pipeline** - From code to production automatically  
✅ **Docker Containerization** - Secure, portable, and scalable  
✅ **Local Testing Setup** - Test GitHub Actions workflows locally  
✅ **Multi-Platform Support** - Works on AMD64 and ARM64 architectures  
✅ **Production Deployment** - Automatic deployment to Render cloud platform  
✅ **Security Best Practices** - Non-root containers, secrets management  
✅ **Modern Development** - ES6 modules, environment configuration, proper Git practices

This project serves as a template for modern Node.js application development with complete DevOps automation.