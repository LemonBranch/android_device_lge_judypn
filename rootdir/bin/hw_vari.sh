#! /vendor/bin/sh

HW_VARI=""
VENDOR_FINGERPRINT=$(grep -w ro.vendor.build.fingerprint /vendor/build.prop | sed -e 's/ro.vendor.build.fingerprint=//;s/^[ \t]*//;s/[ \t].*//')

if [ "$(getprop ro.boot.vendor.lge.fingerprint_sensor)" == "1" ]; then
	log -p i "[LGE][SBP] F should be added!"
	HW_VARI=${HW_VARI}F
fi

if [ "$(getprop ro.boot.vendor.lge.gyro)" == "1" ]; then
	log -p i "[LGE][SBP] G should be added!"
	HW_VARI=${HW_VARI}G
fi

if [ "$(getprop ro.boot.vendor.lge.nfc.vendor)" != "none" ]; then
	log -p i "[LGE][SBP] N should be added!"
	HW_VARI=${HW_VARI}N
fi

if [ $HW_VARI != "" ]; then
	VENDOR_FINGERPRINT=$(echo "${VENDOR_FINGERPRINT}" | sed -r "s/(:user)|(:eng)/.${HW_VARI}&/")
fi

VENDOR_PRODUCT_NAME=$(grep -w ro.product.vendor.name /vendor/build.prop | sed -e 's/ro.product.vendor.name=//;s/^[ \t]*//;s/[ \t].*//')

if [ "$(getprop ro.boot.vendor.lge.ru)" == "1" ]; then
	VENDOR_FINGERPRINT=$(echo "${VENDOR_FINGERPRINT}" | sed -r 's/_com/_ru/')
	VENDOR_PRODUCT_NAME=$(echo "${VENDOR_PRODUCT_NAME}" | sed -r 's/_com/_ru/')
fi

if [ "$(getprop ro.boot.product.lge.eea_type)" != "" ]; then
	VENDOR_FINGERPRINT=$(echo "${VENDOR_FINGERPRINT}" | sed -r "s/_com/_eea/")
	VENDOR_PRODUCT_NAME=$(echo "${VENDOR_PRODUCT_NAME}" | sed -r "s/_com/_eea/")
fi

setprop ro.vendor.lge.build.fingerprint "${VENDOR_FINGERPRINT}"

if [ "$VENDOR_PRODUCT_NAME" != "" ]; then
	setprop ro.vendor.lge.product.name "${VENDOR_PRODUCT_NAME}"
fi

if [ "$(grep -w ro.product.vendor.model /vendor/build.prop | sed -e 's/ro.product.vendor.model=//;s/^[ \t]*//;s/[ \t].*//')" != "" ]; then
	setprop ro.vendor.lge.product.model "$(getprop ro.boot.vendor.lge.product.model)"
fi

exit 0
