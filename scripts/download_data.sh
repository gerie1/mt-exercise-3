#! /bin/bash

scripts=`dirname "$0"`
base=$scripts/..

data=$base/data

mkdir -p $data

tools=$base/tools

# link default training data for easier access

#mkdir -p $data/wikitext-2

#for corpus in train valid test; do
#    absolute_path=$(realpath $tools/pytorch-examples/word_language_model/data/wikitext-2/$corpus.txt)
#    ln -snf $absolute_path $data/wikitext-2/$corpus.txt
#done

# download a different interesting data set!

mkdir -p $data/inaugural_speeches

mkdir -p $data/inaugural_speeches/raw

wget https://www.gutenberg.org/files/925/925.txt
mv 925.txt $data/inaugural_speeches/raw/inaugural_speeches.txt

# preprocess slightly

cat $data/inaugural_speeches/raw/inaugural_speeches.txt | python $base/scripts/preprocess_raw.py > $data/inaugural_speeches/raw/inaugural_speeches.cleaned.txt

# tokenize, fix vocabulary upper bound

cat $data/inaugural_speeches/raw/inaugural_speeches.cleaned.txt | python $base/scripts/preprocess.py --vocab-size 5000 --tokenize --lang "en" --sent-tokenize > \
    $data/inaugural_speeches/raw/inaugural_speeches.preprocessed.txt

# split into train, valid and test

head -n 440 $data/inaugural_speeches/raw/inaugural_speeches.preprocessed.txt | tail -n 400 > $data/inaugural_speeches/valid.txt
head -n 840 $data/inaugural_speeches/raw/inaugural_speeches.preprocessed.txt | tail -n 400 > $data/inaugural_speeches/test.txt
tail -n 3075 $data/inaugural_speeches/raw/inaugural_speeches.preprocessed.txt | head -n 2955 > $data/inaugural_speeches/train.txt
