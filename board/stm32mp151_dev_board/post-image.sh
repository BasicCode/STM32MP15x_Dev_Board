#!/usr/bin/env bash

#
# atf_image extracts the ATF binary image from DTB_FILE_NAME that appears in
# BR2_TARGET_ARM_TRUSTED_FIRMWARE_ADDITIONAL_VARIABLES in ${BR_CONFIG},
# then prints the corresponding file name for the genimage
# configuration file
#
atf_image()
{
	#
	# TODO: Make the FIP image here
	#
	local ATF_VARIABLES="$(sed -n 's/^BR2_TARGET_ARM_TRUSTED_FIRMWARE_ADDITIONAL_VARIABLES="\([\/a-zA-Z0-9_=. \-]*\)"$/\1/p' ${BR2_CONFIG})"

	if grep -Eq "DTB_FILE_NAME=stm32mp151_dev_board-tf-a.dtb" <<< ${ATF_VARIABLES}; then
        echo "tf-a-stm32mp151_dev_board-tf-a.stm32"
	fi
}

main()
{
	local ATFBIN="$(atf_image)"
	local GENIMAGE_CFG="$(mktemp --suffix genimage.cfg)"
	local GENIMAGE_TMP="${BUILD_DIR}/genimage.tmp"

	sed -e "s/%ATFBIN%/${ATFBIN}/" \
		${BR2_EXTERNAL_STM32MP151_Dev_Board_Buildroot_PATH}/board/stm32mp151_dev_board/genimage.cfg.template > ${GENIMAGE_CFG}

	support/scripts/genimage.sh -c ${GENIMAGE_CFG}

	rm -f ${GENIMAGE_CFG}

	exit $?
}

main $@