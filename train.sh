#!/bin/sh
set -x
set -e
export OMP_NUM_THREADS=10
export KMP_INIT_AT_FORK=FALSE

PYTHON=python3

exp_name=$1
config=$2
dataset=$3

TRAIN_CODE=train.py
echo "Training for Flame inverter"


exp_dir=RUN/${dataset}/${exp_name}
model_dir=${exp_dir}/model
result_dir=${exp_dir}/result

now=$(date +"%Y%m%d_%H%M%S")

mkdir -p ${model_dir} ${result_dir}
mkdir -p ${exp_dir}/result

export PYTHONPATH=./
echo $OMP_NUM_THREADS | tee -a ${exp_dir}/train-$now.log
nvidia-smi | tee -a ${exp_dir}/train-$now.log
which pip | tee -a ${exp_dir}/train-$now.log


## TRAIN
$PYTHON -u main/${TRAIN_CODE} \
  --config=${config} \
  save_path ${exp_dir} \
  2>&1 | tee -a ${exp_dir}/train-$now.log
