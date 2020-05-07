#!/usr/bin/env bash
export CFG_REPO=$HOME/transformers_config_mirror
export S3_ENRO="s3://models.huggingface.co/bert/facebook/mbart-large-en-ro/config.json"
export LOCAL_ENRO="$CFG_REPO/mbart_large_en_ro.json"
export S3_CC="s3://models.huggingface.co/bert/facebook/mbart-large-cc25/config.json"

export S3_CNN="s3://models.huggingface.co/bert/facebook/bart-large-cnn/config.json"
export LOCAL_CNN=$CFG_REPO/bart_large_cnn.json

export S3_XSUM="s3://models.huggingface.co/bert/facebook/bart-large-xsum/config.json"
export LOCAL_XSUM=$CFG_REPO/bart_large_xsum.json

export S3_BART_LARGE="s3://models.huggingface.co/bert/facebook/bart-large/config.json"
export LOCAL_BART_LARGE=$CFG_REPO/bart_large.json
alias push_bart_large='s3cmd put $LOCAL_BART_LARGE $S3_BART_LARGE'
export S3_MNLI="s3://models.huggingface.co/bert/facebook/bart-large-mnli/config.json"
export LOCAL_MNLI=$CFG_REPO/bart_large_mnli.json

export S3_TINY="s3://models.huggingface.co/bert/sshleifer/bart-tiny-random/config.json"
export LOCAL_TINY="bart_tiny_random.json"

push_tiny () {
  s3cmd put $LOCAL_TINY $S3_TINY

}
push_mbart () {
  s3cmd put $LOCAL_ENRO $S3_ENRO
  s3cmd put $LOCAL_ENRO $S3_CC

}
pull_mbart () {
  s3cmd get $S3_ENRO $LOCAL_ENRO $@
}

pull_all () {
  s3cmd get $S3_ENRO $LOCAL_ENRO $@
  s3cmd get $S3_CNN $LOCAL_CNN $@
  s3cmd get $S3_XSUM $LOCAL_XSUM $@
  s3cmd get $S3_BART_LARGE $LOCAL_BART_LARGE $@
  s3cmd get $S3_MNLI $LOCAL_MNLI $@
}

sync_helsinki_cfg () {
    s3cmd put --recursive Helsinki-NLP/ s3://models.huggingface.co/bert/Helsinki-NLP/
}
pull_helsinki_cfg () {
	# FIXME
    s3cmd get --recursive Helsinki-NLP/ s3://models.huggingface.co/bert/Helsinki-NLP/
}