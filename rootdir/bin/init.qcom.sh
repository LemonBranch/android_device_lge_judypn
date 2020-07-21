#! /vendor/bin/sh

#
# Copyright (c) 2009-2016, The Linux Foundation. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of The Linux Foundation nor
#       the names of its contributors may be used to endorse or promote
#       products derived from this software without specific prior written
#       permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NON-INFRINGEMENT ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
# OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
# OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
# ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

start_msm_irqbalance()
{
	if [ -f /vendor/bin/msm_irqbalance ]; then
		start vendor.msm_irqbalance
	fi
}

echo 1 > /proc/sys/net/ipv6/conf/default/accept_ra_defrtr

start_msm_irqbalance

chmod g+w -R /data/vendor/modem_config/*
rm -rf /data/vendor/modem_config/*

cp --preserve=m -dr /vendor/firmware_mnt/image/modem_pr/mcfg/configs/* /data/vendor/modem_config
cp --preserve=m -d /vendor/firmware_mnt/verinfo/ver_info.txt /data/vendor/modem_config/
cp --preserve=m -d /vendor/firmware_mnt/image/modem_pr/mbn_ota.txt /data/vendor/modem_config/

chown -hR system.system /data/vendor/modem_config
chmod g+w -R /data/vendor/modem_config/*

target_country="$(getprop ro.vendor.lge.build.target_country)"

case "$(getprop ro.vendor.lge.build.target_operator)" in
	"LGU" | "SKT" | "KT")
		cp --preserve=m -d /data/vendor/modem_config/mcfg_sw/dig_lge/storm_kr.dig /data/vendor/modem_config/mcfg_sw/mbn_sw.dig
		cp --preserve=m -d /data/vendor/modem_config/mcfg_sw/dig_lge/storm_kr.txt /data/vendor/modem_config/mcfg_sw/mbn_sw.txt
		;;
	"OPEN")
		if [ "$target_country" == "KR" ]; then
			cp --preserve=m -d /data/vendor/modem_config/mcfg_sw/dig_lge/storm_kr.dig /data/vendor/modem_config/mcfg_sw/mbn_sw.dig
			cp --preserve=m -d /data/vendor/modem_config/mcfg_sw/dig_lge/storm_kr.txt /data/vendor/modem_config/mcfg_sw/mbn_sw.txt
		elif [ "$target_country" == "US" ]; then
			cp --preserve=m -d /data/vendor/modem_config/mcfg_sw/dig_lge/st_open_.dig /data/vendor/modem_config/mcfg_sw/mbn_sw.dig
			cp --preserve=m -d /data/vendor/modem_config/mcfg_sw/dig_lge/st_open_.txt /data/vendor/modem_config/mcfg_sw/mbn_sw.txt
		fi
		;;
	"ATT")
		cp --preserve=m -d /data/vendor/modem_config/mcfg_sw/dig_lge/st_att_u.dig /data/vendor/modem_config/mcfg_sw/mbn_sw.dig
		cp --preserve=m -d /data/vendor/modem_config/mcfg_sw/dig_lge/st_att_u.txt /data/vendor/modem_config/mcfg_sw/mbn_sw.txt
		;;
	"SPR")
		cp --preserve=m -d /data/vendor/modem_config/mcfg_sw/dig_lge/st_spr_u.dig /data/vendor/modem_config/mcfg_sw/mbn_sw.dig
		cp --preserve=m -d /data/vendor/modem_config/mcfg_sw/dig_lge/st_spr_u.txt /data/vendor/modem_config/mcfg_sw/mbn_sw.txt
		;;
	"USC")
		cp --preserve=m -d /data/vendor/modem_config/mcfg_sw/dig_lge/st_usc_u.dig /data/vendor/modem_config/mcfg_sw/mbn_sw.dig
		cp --preserve=m -d /data/vendor/modem_config/mcfg_sw/dig_lge/st_usc_u.txt /data/vendor/modem_config/mcfg_sw/mbn_sw.txt
		;;
	"VZW")
		cp --preserve=m -d /data/vendor/modem_config/mcfg_sw/dig_lge/st_vzw_u.dig /data/vendor/modem_config/mcfg_sw/mbn_sw.dig
		cp --preserve=m -d /data/vendor/modem_config/mcfg_sw/dig_lge/st_vzw_u.txt /data/vendor/modem_config/mcfg_sw/mbn_sw.txt
		;;
	"NAO")
		if [ "$target_country" == "US" ]; then
			cp --preserve=m -d /data/vendor/modem_config/mcfg_sw/dig_lge/st_open_.dig /data/vendor/modem_config/mcfg_sw/mbn_sw.dig
			cp --preserve=m -d /data/vendor/modem_config/mcfg_sw/dig_lge/st_open_.txt /data/vendor/modem_config/mcfg_sw/mbn_sw.txt
		fi
		;;
	"TMO")
		cp --preserve=m -d /data/vendor/modem_config/mcfg_sw/dig_lge/st_tmo_u.dig /data/vendor/modem_config/mcfg_sw/mbn_sw.dig
		cp --preserve=m -d /data/vendor/modem_config/mcfg_sw/dig_lge/st_tmo_u.txt /data/vendor/modem_config/mcfg_sw/mbn_sw.txt
		;;
esac

chmod g-w -R /data/vendor/modem_config/*
chmod g-w /data/vendor/modem_config

echo 1 > /data/vendor/radio/copy_complete

case "$(getprop ro.build.type)" in
	"userdebug" | "eng")
		echo "6 6 1 7" > /proc/sys/kernel/printk
		;;
	*)
		echo "4 4 1 4" > /proc/sys/kernel/printk
		;;
esac
