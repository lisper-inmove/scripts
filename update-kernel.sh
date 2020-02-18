#!/usr/bin/env bash

# 日志函数
function log()
{
    local _level=$1
    shift
    local _msg=$*
    local _ts=$(date +"%F %T")
    case $_level in
        info) echo -e "$_ts [INFO] $_msg";;
        notice) echo -e "$_ts [NOTE] \033[92m$_msg\033[0m";;
        warn) echo -e "$_ts [WARN] \033[93m$_msg\033[0m";;
        error) echo -e "$_ts [ERROR] \033[91m$_msg\033[0m";;
    esac
}

function up_kernel() {
    log notice "添加yum源..."
    rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
    rpm -Uvh https://www.elrepo.org/elrepo-release-7.0-3.el7.elrepo.noarch.rpm
    log notice "列出可用内核..."
    yum --disablerepo="*" --enablerepo="elrepo-kernel" list available
    log notice "安装最新稳定版内核..."
    yum --enablerepo=elrepo-kernel install kernel-ml  -y
    log notice "设置使用新内核启动"
    grub2-set-default 0
}

up_kernel
