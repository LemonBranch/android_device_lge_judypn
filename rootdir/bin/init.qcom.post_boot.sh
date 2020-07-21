#! /vendor/bin/sh

#
# Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
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

echo f > /proc/irq/default_smp_affinity

echo 2 > /proc/irq/7/smp_affinity_list
echo 1 > /proc/irq/496/smp_affinity_list

echo 2 > /sys/devices/system/cpu/cpu4/core_ctl/min_cpus
echo 60 > /sys/devices/system/cpu/cpu4/core_ctl/busy_up_thres
echo 30 > /sys/devices/system/cpu/cpu4/core_ctl/busy_down_thres
echo 100 > /sys/devices/system/cpu/cpu4/core_ctl/offline_delay_ms
echo 1 > /sys/devices/system/cpu/cpu4/core_ctl/is_big_cluster
echo 4 > /sys/devices/system/cpu/cpu4/core_ctl/task_thres

echo 95 > /proc/sys/kernel/sched_upmigrate
echo 85 > /proc/sys/kernel/sched_downmigrate
echo 100 > /proc/sys/kernel/sched_group_upmigrate
echo 95 > /proc/sys/kernel/sched_group_downmigrate
echo 1 > /proc/sys/kernel/sched_walt_rotate_big_tasks

echo "schedutil" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
echo 500 > /sys/devices/system/cpu/cpu0/cpufreq/schedutil/up_rate_limit_us
echo 20000 > /sys/devices/system/cpu/cpu0/cpufreq/schedutil/down_rate_limit_us
echo 1209600 > /sys/devices/system/cpu/cpu0/cpufreq/schedutil/hispeed_freq
echo 1 > /sys/devices/system/cpu/cpu0/cpufreq/schedutil/pl
echo 576000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq

echo "schedutil" > /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor
echo 500 > /sys/devices/system/cpu/cpu4/cpufreq/schedutil/up_rate_limit_us
echo 20000 > /sys/devices/system/cpu/cpu4/cpufreq/schedutil/down_rate_limit_us
echo 1574400 > /sys/devices/system/cpu/cpu4/cpufreq/schedutil/hispeed_freq
echo 1 > /sys/devices/system/cpu/cpu4/cpufreq/schedutil/pl
echo "0:1766400 4:1056000" > /sys/module/cpu_boost/parameters/input_boost_freq
echo "0:1766400 4:902400" > /sys/module/cpu_boost/parameters/sub_boost_freq
echo 160 > /sys/module/cpu_boost/parameters/input_boost_ms
echo 825000 > /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq

for cpubw in /sys/class/devfreq/*qcom,cpubw*; do
	echo "bw_hwmon" > "$cpubw/governor"
	echo 50 > "$cpubw/polling_interval"
	echo "2288 4577 6500 8132 9155 10681" > "$cpubw/bw_hwmon/mbps_zones"
	echo 4 > "$cpubw/bw_hwmon/sample_ms"
	echo 50 > "$cpubw/bw_hwmon/io_percent"
	echo 20 > "$cpubw/bw_hwmon/hist_memory"
	echo 10 > "$cpubw/bw_hwmon/hyst_length"
	echo 0 > "$cpubw/bw_hwmon/guard_band_mbps"
	echo 250 > "$cpubw/bw_hwmon/up_scale"
	echo 1600 > "$cpubw/bw_hwmon/idle_mbps"
done

for llccbw in /sys/class/devfreq/*qcom,llccbw*; do
	echo "bw_hwmon" > "$llccbw/governor"
	echo 50 > "$llccbw/polling_interval"
	echo "1720 2929 3879 5931 6881" > "$llccbw/bw_hwmon/mbps_zones"
	echo 4 > "$llccbw/bw_hwmon/sample_ms"
	echo 80 > "$llccbw/bw_hwmon/io_percent"
	echo 20 > "$llccbw/bw_hwmon/hist_memory"
	echo 10 > "$llccbw/bw_hwmon/hyst_length"
	echo 0 > "$llccbw/bw_hwmon/guard_band_mbps"
	echo 250 > "$llccbw/bw_hwmon/up_scale"
	echo 1600 > "$llccbw/bw_hwmon/idle_mbps"
done

for memlat in /sys/class/devfreq/*qcom,memlat-cpu*; do
	echo "mem_latency" > "$memlat/governor"
	echo 10 > "$memlat/polling_interval"
	echo 400 > "$memlat/mem_latency/ratio_ceil"
done

for memlat in /sys/class/devfreq/*qcom,l3-cpu*; do
	echo "mem_latency" > "$memlat/governor"
	echo 10 > "$memlat/polling_interval"
	echo 400 > "$memlat/mem_latency/ratio_ceil"
done

for l3cdsp in /sys/class/devfreq/*qcom,l3-cdsp*; do
	echo "userspace" > "$l3cdsp/governor"
	chown -h system "$l3cdsp/userspace/set_freq"
done

echo 4000 > /sys/class/devfreq/soc:qcom,l3-cpu4/mem_latency/ratio_ceil

echo "compute" > /sys/class/devfreq/soc:qcom,mincpubw/governor
echo 10 > /sys/class/devfreq/soc:qcom,mincpubw/polling_interval

echo 0-1 > /dev/cpuset/background/cpus
echo 0-2 > /dev/cpuset/system-background/cpus
echo 0-3 > /dev/cpuset/restricted/cpus
echo 0-3,5-6 > /dev/cpuset/foreground/cpus

echo 1 > /dev/stune/foreground/schedtune.prefer_idle
echo 10 > /dev/stune/top-app/schedtune.boost
echo 1 > /dev/stune/top-app/schedtune.prefer_idle

echo 1000 > /dev/blkio/blkio.weight
echo 200 > /dev/blkio/background/blkio.weight
echo 2000 > /dev/blkio/blkio.group_idle
echo 0 > /dev/blkio/background/blkio.group_idle

echo 0 > /proc/sys/kernel/sched_boost

echo N > /sys/module/lpm_levels/L3/cpu0/ret/idle_enabled
echo N > /sys/module/lpm_levels/L3/cpu1/ret/idle_enabled
echo N > /sys/module/lpm_levels/L3/cpu2/ret/idle_enabled
echo N > /sys/module/lpm_levels/L3/cpu3/ret/idle_enabled
echo N > /sys/module/lpm_levels/L3/cpu4/ret/idle_enabled
echo N > /sys/module/lpm_levels/L3/cpu5/ret/idle_enabled
echo N > /sys/module/lpm_levels/L3/cpu6/ret/idle_enabled
echo N > /sys/module/lpm_levels/L3/cpu7/ret/idle_enabled
echo N > /sys/module/lpm_levels/L3/l3-dyn-ret/idle_enabled

echo 0 > /sys/module/lpm_levels/parameters/sleep_disabled

echo 100 > /proc/sys/vm/swappiness
echo 120 > /proc/sys/vm/watermark_scale_factor

setprop vendor.powerhal.init 1

setprop vendor.post_boot.parsed 1

if [ -f /data/prebuilt/AdrenoTest.apk ]; then
	if [ ! -d /data/data/com.qualcomm.adrenotest ]; then
		pm install /data/prebuilt/AdrenoTest.apk
	fi
fi

if [ -f /data/prebuilt/SWE_AndroidBrowser.apk ]; then
	if [ ! -d /data/data/com.android.swe.browser ]; then
		pm install /data/prebuilt/SWE_AndroidBrowser.apk
	fi
fi

if [ -f /sys/devices/soc0/select_image ]; then
	image_version="10:$(getprop ro.build.id):$(getprop ro.build.version.incremental)"
	image_variant="$(getprop ro.product.name)-$(getprop ro.build.type)"
	oem_version="$(getprop ro.build.version.codename)"
	echo 10 > /sys/devices/soc0/select_image
	echo "$image_version" > /sys/devices/soc0/image_version
	echo "$image_variant" > /sys/devices/soc0/image_variant
	echo "$oem_version" > /sys/devices/soc0/image_crm_version
fi

echo "Enable console config to "

misc_link=$(ls -l /dev/block/bootdevice/by-name/misc)
real_path=${misc_link##*>}

setprop persist.vendor.mmi.misc_dev_path "$real_path"
