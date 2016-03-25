#!/bin/bash
#
# Convert Letter source to A4

main () {
  for style in $(styles) ; do
    for page_num in $(page_numbers) ; do
      local source=$(source_file $style $page_num)
      local target=$(target_name $style 'A4')

      convert_page ${source} ${target} ${page_num}
    done
    collate ${target}
  done
}

convert_page () {
  local source=${1}
  local target_name=${2}
  local page_num=${3}

  local target_dir=${target_name}/pages
  local target_file=${target_name}/pages/Chart-$(pad ${page_num}).pdf

  local opts="-q -sDEVICE=pdfwrite -sPAPERSIZE=a4 -dFIXEDMEDIA -dPDFFitPage -dCompatibilityLevel=1.4"

  echo "Convert: $source -> $target_file" >&2
  echo "  gs $opts -o $target_file $source" >&2

  mkdir -p ${target_dir}
  gs $opts -o ${target_file} ${source}
}

source_file () {
  local style=$1
  local num=$2
  echo "source/Mag7-$style/Chart-$num.pdf"
}

target_name () {
  local style=$1
  local size=$2
  local dir="target/Mag7/$style/$size"

  mkdir -p ${dir}
  echo ${dir}
}

collate () {
  local target_dir=${1}/pages
  local target_file=${1}-All.pdf
  local opts="-q -sDEVICE=pdfwrite -sPAPERSIZE=a4 -dFIXEDMEDIA -dPDFFitPage -dCompatibilityLevel=1.4"

  echo "Collate: $target_name" >&2
  echo "  gs $opts -o $target_file $target_dir/*.pdf" >&2
  gs $opts -o ${target_file} ${target_dir}/*.pdf
}

target_file () {
  local dirname=$(target_dir $@)
  local style=$1
  local num=$2
  local filename="Chart-$(pad $num).pdf"
  local dirname="target/Mag7-$style-A4"

  echo ${dirname}/${filename}
}

pad () {
  if [[ ${1} =~ ^[0-9]$ ]]; then
    echo "0$1"
  else
    echo "$1"
  fi
}

page_numbers () {
  local head=$(seq 1 11)
  local tail=$(seq 12 20)
  echo "$head 11a $tail"
}

styles () {
  echo BW
  return
  echo "BW COLOR"
}

main
