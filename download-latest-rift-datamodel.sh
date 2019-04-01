#!/bin/bash

# Clone bitbucket repository that contains that RIFT drafts to temporary directory
#
LOCAL_REPO='/tmp/rift_draft'
#git clone https://bitbucket.org/riftrfc/rift_draft.git ${LOCAL_REPO}

# Determine the most recent RIFT draft
#
LATEST_DRAFT=$(basename $(ls ${LOCAL_REPO}/draft-ietf-rift-??.xml | sort | tail -n 1))

# Store information about when and from which draft the data model was most recently downloaded
#
echo "Latest model download date: $(date)" > download-info.txt
echo "Model taken from draft: ${LATEST_DRAFT}" >> download-info.txt

# Extract common.thrift from the draft
#
cp ${LOCAL_REPO}/${LATEST_DRAFT} common.thrift
sed -i .bak -e '1,/section title="common.thrift"/d' common.thrift
sed -i .bak -e '1,/artwork/d' common.thrift
sed -i .bak -e '/\/artwork/,$d' common.thrift
awk -f remove-leading-and-trailing-blank-lines.awk common.thrift > common.thrift.tmp
mv common.thrift.tmp common.thrift
rm common.thrift.bak

# Extract encoding.thrift from the draft
#
cp ${LOCAL_REPO}/${LATEST_DRAFT} encoding.thrift
sed -i .bak -e '1,/section title="common.thrift"/d' encoding.thrift
sed -i .bak -e '1,/artwork/d' encoding.thrift
sed -i .bak -e '/\/artwork/,$d' encoding.thrift
awk -f remove-leading-and-trailing-blank-lines.awk common.thrift > encoding.thrift.tmp
mv encoding.thrift.tmp encoding.thrift
rm encoding.thrift.bak

# Clean up the temporary directory
#
#rm -rf ${LOCAL_REPO}