#!/bin/bash
# sync-docker-to-git.sh

CONTAINER_ID=$1
NEW_TAG=$2
COMMIT_MESSAGE=$3

if [ -z "$CONTAINER_ID" ] || [ -z "$NEW_TAG" ] || [ -z "$COMMIT_MESSAGE" ]; then
    echo "Usage: $0 <container_id> <new_tag> <commit_message>"
    echo "Example: $0 cf14d00be54a 1.0.1 'Fixed ROS 2 PATH'"
    exit 1
fi

# 1. Commit container to new tag
docker commit -m "$COMMIT_MESSAGE" -a "$(git config user.name)" \
    $CONTAINER_ID leticiarp2000/ubuntu20_dji_manifold3:$NEW_TAG

# 2. Push to Docker Hub
docker push leticiarp2000/ubuntu20_dji_manifold3:$NEW_TAG

# 3. Update Dockerfile with version
cd ~/Ubuntu20.04-DocerImage
sed -i "s/LABEL version=\"[^\"]*\"/LABEL version=\"$NEW_TAG\"/" Dockerfile

# 4. Commit to Git
git add Dockerfile
git commit -S -m "fix: $COMMIT_MESSAGE (version $NEW_TAG)"
git push origin main

echo "✅ Changes synced:"
echo "  - Docker Hub: leticiarp2000/ubuntu20_dji_manifold3:$NEW_TAG"
echo "  - Git: Updated Dockerfile version to $NEW_TAG"
