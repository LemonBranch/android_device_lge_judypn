#! /vendor/bin/sh

#
# Copyright (c) 2013-2014, The Linux Foundation. All rights reserved.
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

datamode="$(getprop persist.vendor.data.mode)"

start vendor.qmuxd

stop ril-daemon
stop vendor.ril-daemon
start vendor.qcrild

start vendor.ipacm-diag
start vendor.ipacm

setprop persist.vendor.radio.voice.modem.index 0

multisim="$(getprop persist.radio.multisim.config)"
multisim_vts="$(getprop ro.boot.vendor.lge.dsds)"

case "$multisim" in
	"dsda" | "dsds" | "tsts")
		start vendor.qcrild2
		;;
esac

case "$multisim_vts" in
	"dsds" | "tsts")
		start vendor.qcrild2
		;;
esac

if [ "$multisim" == "tsts" ] || [ "$multisim_vts" == "tsts" ]; then
	start vendor.qcrild3
fi

case "$datamode" in
	"tethered")
		start vendor.dataqti
		start vendor.dataadpl
		start vendor.port-bridge
		;;
	"concurrent")
		start vendor.dataqti
		start vendor.dataadpl
		start vendor.netmgrd
		start vendor.port-bridge
		;;
	*)
		start vendor.netmgrd
		;;
	esac

fake_batt_capacity="$(getprop persist.vendor.bms.fake_batt_capacity)"

case "$fake_batt_capacity" in
	"") ;;
	* )
		echo "$fake_batt_capacity" > /sys/class/power_supply/battery/capacity
		;;
esac
