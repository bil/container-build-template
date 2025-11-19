#!/bin/bash

if [ -z "$(ls ./installation_scripts/)" ]; then
        echo "This utility cannot be used without installation scripts."
fi

base=$(yq '.base' engine_instructions.yaml)
curdir=$(basename $(pwd))

rm -f ./containerfiles/*.cf 

for image in $(yq '.images[]' engine_instructions.yaml); do
	
	if [[ -z ${prev+x} ]]; then
		from=$base
	else
		from=$prev
	fi
	
	cat > ./containerfiles/${image}.cf <<-EOF
	FROM ${from} 

	ARG SH_SCRIPT=${image}.sh
	ARG TMPDIR=/tmp
	
	COPY ./${curdir}/installation_scripts/\$SH_SCRIPT \$TMPDIR
	
	RUN \\
	    bash \$TMPDIR/\$SH_SCRIPT    && \\
	    rm \$TMPDIR/\$SH_SCRIPT
	EOF
	
	prev=$image
done

echo "FROM $prev" > ./containerfiles/final.cf

yq -r '.instructions.COPY[] | [.src, .dst] | map(tostring) | join(" ")' engine_instructions.yaml | awk '{print "COPY", $1, $2}' >> ./containerfiles/final.cf

echo ENTRYPOINT $(yq -oj -I=0 '.instructions.ENTRYPOINT' engine_instructions.yaml) >> ./containerfiles/final.cf

echo CMD $(yq -oj -I=0 '.instructions.CMD' engine_instructions.yaml) >> ./containerfiles/final.cf
