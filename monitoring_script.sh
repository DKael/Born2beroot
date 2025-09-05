#!/bin/bash

# Locale 고정
export LC_ALL=C

# 1) Architecture
echo "#Architecture: $(uname -a)"

# 2) CPU physical / vCPU
cpu_physical=$(grep "physical id" /proc/cpuinfo 2>/dev/null | sort -u | wc -l)
[ "$cpu_physical" -eq 0 ] && cpu_physical=$(lscpu 2>/dev/null | awk -F: '/Socket\(s\)/{gsub(/ /,"",$2); print $2+0}')
[ -z "$cpu_physical" ] && cpu_physical=1
echo "#CPU physical: $cpu_physical"

vcpu=$(grep -c ^processor /proc/cpuinfo 2>/dev/null)
[ "$vcpu" -le 0 ] && vcpu=$(nproc --all 2>/dev/null)
echo "#vCPU: $vcpu"

# 3) Memory Usage
read _ total used _ < <(free -m | awk '/^Mem:/{print $1, $2, $3, $4}')
pmem=$(awk -v u="$used" -v t="$total" 'BEGIN{if(t>0) printf "%.2f", (u/t)*100; else print "0.00"}')
echo "#Memory Usage: $used/$total MB ($pmem%)"

# 4) Disk Usage
read used_k total_k < <(df -P --output=used,size | awk 'NR>1{u+=$1; t+=$2} END{print u, t}')
used_g=$(awk -v u="$used_k" 'BEGIN{printf "%.0f", u/1024/1024}')
total_g=$(awk -v t="$total_k" 'BEGIN{printf "%.0f", t/1024/1024}')
pdisk=$(awk -v u="$used_k" -v t="$total_k" 'BEGIN{if(t>0) printf "%.0f", (u/t)*100; else print 0}')
echo "#Disk Usage: $used_g/$total_g GB ($pdisk%)"

# 5) CPU load
read cpu user nice system idle iowait irq softirq steal guest guest_nice < /proc/stat
idle_prev=$idle; total_prev=$((user+nice+system+idle+iowait+irq+softirq+steal))
sleep 1
read cpu user nice system idle iowait irq softirq steal guest guest_nice < /proc/stat
idle_now=$idle; total_now=$((user+nice+system+idle+iowait+irq+softirq+steal))
idle_delta=$((idle_now - idle_prev))
total_delta=$((total_now - total_prev))
cpu_usage=$(awk -v i="$idle_delta" -v t="$total_delta" 'BEGIN{if(t>0) printf "%.2f", (1 - i/t)*100; else print "0.00"}')
echo "#CPU load: $cpu_usage%"

# 6) Last boot
echo "#Last boot: $(who -b | awk '{print $3, $4}')"

# 7) LVM use
lvm_u="no"
lsblk | awk '{print $6}' | grep -qw lvm && lvm_u="yes"
echo "#LVM use: $lvm_u"

# 8) Connections TCP
tcp_n=$(ss -tanH | grep -c ESTAB)
echo "#Connections TCP: $tcp_n ESTABLISHED"

# 9) User log
echo "#User log: $(who | wc -l)"

# 10) Network
ip_list=$(hostname -I | xargs)
mac_addr=$(ip link | awk '/link\/ether/{print $2; exit}')
echo "#Network: IP $ip_list ($mac_addr)"

# 11) Sudo
sudo_count=0
for f in /var/log/sudo.log /var/log/sudo/sudo.log /var/log/auth.log; do
  [ -r "$f" ] && c=$(grep -c "COMMAND=" "$f") && sudo_count=$((sudo_count + c))
done
echo "#Sudo: $sudo_count cmd"

# 12) Inodes Usage
read iused itotal < <(df -Pi --output=iused,itotal | awk 'NR>1{i+=$1; t+=$2} END{print i, t}')
iper=$(awk -v u="$iused" -v t="$itotal" 'BEGIN{if(t>0) printf "%.0f", (u/t)*100; else print 0}')
echo "#Inodes Usage: $iused/$itotal ($iper%)"

# 13) Listening
tcp_listen=$(ss -tanlH | grep -c LISTEN)
udp_listen=$(ss -uanH | wc -l)
listen_total=$((tcp_listen + udp_listen))
echo "#Listening: $listen_total (TCP: $tcp_listen | UDP: $udp_listen)"

# 14) Processes
procs=$(ps -e --no-headers | wc -l)
echo "#Processes: $procs"
