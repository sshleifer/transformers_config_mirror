from transformers.hf_api import HfApi

import os
import json

import sys
from pathlib import Path
MIRROR_DIR = Path('/Users/shleifer/transformers-config-mirror/')
from transformers import MarianConfig
from durbango import tqdm_nice

DEFAULT_UPDATE_DICT = {'max_length': 512}
def bulk_update_local_configs(models, update_dict=DEFAULT_UPDATE_DICT,
                              save_dir=MIRROR_DIR):
    failures = []
    for slug in tqdm_nice(models):
        assert slug.startswith('opus-mt')
        try:
            cfg = MarianConfig.from_pretrained(f'Helsinki-NLP/{slug}')
        except OSError:
            failures.append(slug)
            continue
        for k,v in update_dict.items():
            setattr(cfg, k, v)
        # if a new value depends on a cfg value, add code here
        # e.g. cfg.decoder_start_token_id = cfg.pad_token_id

        dest_dir = (save_dir/'Helsinki-NLP'/ slug)
        if not dest_dir.exists():
            print(f'making {dest_dir}')
            dest_dir.mkdir(exist_ok=True)
        cfg.save_pretrained(dest_dir)
        assert cfg.from_pretrained(dest_dir).model_type == 'marian'


def update_config(model_identifier, updates):
    api = HfApi()
    model_list = api.model_list()
    model_dict = [
        model_dict
        for model_dict in model_list
        if model_dict.modelId == model_identifier
    ][0]

    model_identifier = "_".join(model_identifier.split("/"))

    http = "https://s3.amazonaws.com/"
    hf_url = "models.huggingface.co/"
    config_path_aws = http + hf_url + model_dict.key
    file_name = f"./{model_identifier}_config.json"

    bash_command = f"curl {config_path_aws} > {file_name}"
    os.system(bash_command)

    with open(file_name) as f:
        config_json = json.load(f)

    bash_command = "rm {}".format(file_name)
    os.system(bash_command)

    ##### HERE YOU SHOULD STATE WHICH PARAMS WILL BE CHANGED #####
    config_json.update(updates)

    # save config as it was saved before
    with open(file_name, "w") as f:
        json.dump(config_json, f, indent=2, sort_keys=True)

    # upload new config
    bash_command = f"s3cmd cp {file_name} s3://{hf_url + model_dict.key}"
    os.system(bash_command)


if __name__ == "__main__":
    model_identifier = sys.argv[1]
    update_config(model_identifier)
