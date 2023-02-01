git fetch --all --tags
export LASTMESSAGE=`git log -1 --format=%s`
export BRANCH=`git branch --show-current`
echo "$BRANCH->$LASTMESSAGE"
RES=$(git show-ref --tags |grep 0)
if [ -z "$RES" ]; then
    NEW_TAG=0.0.0-dev
else
    # NEW_TAG=$(git describe --tags --abbrev=0 | awk -F. '{OFS="."; $NF+=1; print $0}')
    # NEW_TAG=$(git describe --tags `git rev-list --tags --max-count=1` | awk -F. '{OFS="."; $NF+=1; print $1,$2,$3"-dev"}')
    NEW_TAG=$(git describe --match "0.*" | awk -F. '{OFS="."; $NF+=1; print $1,$2,$3"-dev"}')
fi
echo $NEW_TAG
git tag -a $NEW_TAG -m "$BRANCH->$LASTMESSAGE" && git push origin --tags






