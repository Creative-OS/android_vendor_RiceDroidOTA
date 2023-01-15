#!/bin/bash
#put script in crDroid source folder, make executable (chmod +x createupdate.sh) and run it (./createupdate.sh)

#modify values below
#leave blank if not used
version="10.1"
buildtype="PIXEL"
maintainer="NivlaFX" #ex: Lup Gabriel (gwolfu)
oem="Motorola" #ex: OnePlus
device="racer" #ex: guacamole
devicename="Edge" #ex: OnePlus 7 Pro
zip="riceDroid-13.0-$(date +%Y%m%d%H%M)-$device-v$version-$buildtype-OFFICIAL.zip" #ex: crDroidAndroid-<android version>-<date>-<device codename>-v<ricedroid version>.zip
buildtype="Beta" #choose from Testing/Alpha/Beta/Weekly/Monthly
forum="https://t.me/CreativeRaviole" #https link (mandatory)
gapps="" #https link (leave empty if unused)
firmware="" #https link (leave empty if unused)
modem="" #https link (leave empty if unused)
bootloader="" #https link (leave empty if unused)
recovery="" #https link (leave empty if unused)
paypal="" #https link (leave empty if unused)
telegram="https://t.me/CreativeRaviole" #https link (leave empty if unused)
dt="https://github.com/Creative-OS/android_device_motorola_racer" #https://github.com/ricedroidandroid/android_device_<oem>_<device_codename>
commondt="" #https://github.com/ricedroidandroid/android_device_<orm>_<SOC>-common
kernel="https://github.com/Creative-OS/android_kernel_motorola_gs101" #https://github.com/ricedroidandroid/android_kernel_<oem>_<SOC>
#Sourceforge RSync Info
username="nivlafx" #sourceforge username nivlafx
projectname="creative-oss" #sourceforge project name
build_out="../../" #Path leading to the start of the output dir, Already set correctly
file_name="$build_out/out/target/product/$device/$zip" #Already set correctly

#don't modify from here
out_path="../../"
script_path="`dirname \"$0\"`"
zip_name=$out_path/out/target/product/$device/$zip
buildprop=$out_path/out/target/product/$device/system/build.prop
changelog=$out_path/out/target/product/$device/Changelog.txt
sourceforgesync="rsync -e ssh $file_name $username@frs.sourceforge.net:/home/frs/project/$projectname/$device/10.x"

if [ -f $script_path/$device.json ]; then
  rm $script_path/$device.json
fi
if [ -f $script_path/changelog_$device.txt ]; then
  rm $script_path/changelog_$device.txt
fi

cp $changelog changelog_$device.txt

linenr=`grep -n "ro.system.build.date.utc" $buildprop | cut -d':' -f1`
timestamp=`sed -n $linenr'p' < $buildprop | cut -d'=' -f2`
zip_only=`basename "$zip_name"`
md5=`md5sum "$zip_name" | cut -d' ' -f1`
sha256=`sha256sum "$zip_name" | cut -d' ' -f1`
size=`stat -c "%s" "$zip_name"`
version=`echo "$zip_only" | cut -d'-' -f5`
v_max=`echo "$version" | cut -d'.' -f1 | cut -d'v' -f2`
v_min=`echo "$version" | cut -d'.' -f2`
version=`echo $v_max.$v_min`

echo '{
  "response": [
    {
        "maintainer": "'$maintainer'",
        "oem": "'$oem'",
        "device": "'$devicename'",
        "filename": "'$zip_only'",
        "download": "https://sourceforge.net/projects/creative-oss/files/'$device'/'$v_max'.x/'$zip_only'/download",
        "timestamp": '$timestamp',
        "md5": "'$md5'",
        "sha256": "'$sha256'",
        "size": '$size',
        "version": "'$version'",
        "buildtype": "'$buildtype'",
        "forum": "'$forum'",
        "gapps": "'$gapps'",
        "firmware": "'$firmware'",
        "modem": "'$modem'",
        "bootloader": "'$bootloader'",
        "recovery": "'$recovery'",
        "paypal": "'$paypal'",
        "telegram": "'$telegram'",
        "dt": "'$dt'",
        "common-dt": "'$commondt'",
        "kernel": "'$kernel'"
    }
  ]
}' >> $device.json

$sourceforgesync
