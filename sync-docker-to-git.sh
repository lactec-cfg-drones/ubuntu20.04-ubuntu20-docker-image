#!/bin/bash
# sync-docker-to-git.sh - Improved with version tracking

set -e

echo "Syncing Docker image with Git repository..."

# Get current Git commit
GIT_COMMIT=$(git rev-parse --short HEAD)
GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
VERSION=${1:-"1.0.3"}
COMMIT_MSG=${2:-"Update Docker image to version $VERSION (commit: $GIT_COMMIT)"}

echo "Git commit: $GIT_COMMIT on branch: $GIT_BRANCH"
echo "Building version: $VERSION"

# Step 1: Commit any changes to Git
echo "Committing changes to Git..."
git add Dockerfile
git add *.sh
git add *.md
git add .github/ 2>/dev/null || true
git commit -m "$COMMIT_MSG" || echo "No changes to commit"
git push origin $GIT_BRANCH

# Step 2: Build Docker image with build args
echo "Building Docker image: leticiarp2000/ubuntu20_dji_manifold3:$VERSION"
docker build \
  --build-arg VERSION=$VERSION \
  --build-arg GIT_COMMIT=$GIT_COMMIT \
  --build-arg BUILD_DATE="$(date -u +'%Y-%m-%dT%H:%M:%SZ')" \
  -t leticiarp2000/ubuntu20_dji_manifold3:$VERSION .

# Step 3: Tag as latest
docker tag leticiarp2000/ubuntu20_dji_manifold3:$VERSION \
  leticiarp2000/ubuntu20_dji_manifold3:latest

# Step 4: Test the image
echo "Testing image..."
docker run --rm leticiarp2000/ubuntu20_dji_manifold3:$VERSION \
  test -f /root/Payload-SDK/VERSION || exit 1

docker run --rm leticiarp2000/ubuntu20_dji_manifold3:$VERSION \
  cat /root/Payload-SDK/VERSION

# Step 5: Push to Docker Hub
echo "⬆Pushing to Docker Hub..."
docker push leticiarp2000/ubuntu20_dji_manifold3:$VERSION
docker push leticiarp2000/ubuntu20_dji_manifold3:latest

# Step 6: Create Git tag
echo "Creating Git tag: v$VERSION"
git tag -a "v$VERSION" -m "Release version $VERSION (commit: $GIT_COMMIT)"
git push origin "v$VERSION"

echo "Success!"
echo "  - Version: $VERSION"
echo "  - Commit: $GIT_COMMIT"
echo "  - Image: leticiarp2000/ubuntu20_dji_manifold3:$VERSION"
echo "  - Image: leticiarp2000/ubuntu20_dji_manifold3:latest"