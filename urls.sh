#!/usr/bin/env bash

export S3_ENRO="s3://models.huggingface.co/bert/facebook/mbart-large-en-ro/config.json"
export LOCAL_ENRO="$HOME/transformers_config_mirror/mbart_large_en_ro.json"
export S3_CC="s3://models.huggingface.co/bert/facebook/mbart-large-cc25/config.json"


push_mbart () {
  s3cmd put $LOCAL_ENRO $S3_ENRO
  s3cmd put $LOCAL_ENRO $S3_CC

}
pull_mbart () {
  s3cmd get $S3_ENRO $LOCAL_ENRO $@
}
