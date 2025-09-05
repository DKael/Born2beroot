# Born2beroot

## 1️⃣ 프로젝트 소개

Born2beroot는 리눅스 운영체제를 설치하고 보안 규칙 및 사용자 관리, 서비스 설정 등을 직접 수행하는 시스템 관리 프로젝트입니다.
단순한 서버 설치가 아니라, 최소한의 환경에서 보안 정책을 수립하고 시스템 관리 자동화까지 구현하는 데 초점을 맞추고 있습니다.
보너스 과제까지 포함하면, 추가적인 서비스(예: WordPress, FTP, UFW 방화벽 강화, 포트 설정) 등을 설정하여 실제 서버 운영과 유사한 환경을 구축할 수 있습니다.

---

## 2️⃣ 과제 목표
	•	리눅스 운영체제 설치 (예: Debian, Rocky Linux, CentOS 등)
	•	보안 정책 강화: 강력한 비밀번호 정책, sudo 보안 설정
	•	사용자 및 그룹 관리: 개발자/관리자 그룹 분리, 권한 제어
	•	필수 서비스 설정: SSH, 방화벽(UFW/iptables), cron job 자동화
	•	보너스: 추가 서비스 설치(WordPress, MariaDB, vsftpd, UFW 고급 설정)

---

## 3️⃣ 구현 사항

### ✅ 기본 구현
* 운영체제 설치: VirtualBox 환경에서 Debian 기반 OS 설치
* 사용자 및 그룹 관리
  - useradd, groupadd를 통한 사용자/그룹 생성
  - sudo 그룹 설정 및 권한 제한
* 비밀번호 정책 강화
  - /etc/login.defs, PAM 모듈 편집
  - 비밀번호 최소 길이, 대문자/숫자/특수문자 조합 필수
  - 비밀번호 만료일(30일), 경고일(7일) 설정
* sudo 보안 설정
  - sudo 실행 시 custom 메시지 출력
  - sudo 사용 기록 로깅 (/var/log/sudo/)
* 서비스 설정
  - SSH 포트 변경 및 root 로그인 차단
  - UFW 방화벽 기본 정책 설정 (deny incoming / allow outgoing)
  - cron job 등록 (예: 10분마다 시스템 모니터링 로그 기록)

### ✅ 보너스 구현
* WordPress + MariaDB 설치 및 설정
  - LAMP/LEMP 스택 구성 (Nginx + PHP + MariaDB)
  - WordPress DB 생성 및 계정 권한 설정
* vsftpd 서버 구성
  - FTP 사용자 전용 계정 생성
  - TLS 기반 보안 FTP 설정
* 방화벽 고급 설정
  - 특정 포트만 허용 (22, 80, 443)
  - 불필요한 서비스 포트 차단
* 모니터링 자동화 스크립트
  - bash 스크립트로 CPU, RAM, Disk, Network 사용량 수집
  - cron job으로 10분마다 실행하여 /var/log/monitoring.log에 기록

---

## 4️⃣ Project 정리

## 1. General Instructions
* signature.txt는 repository root에 존재해야 함.
* .vdi 파일의 signature와 제출 signature가 일치해야 함.

---

## 2. Mandatory Part

### (1) Project Overview
* Virtual Machine (VM): 물리 서버에서 Hypervisor를 통해 여러 OS를 구동하는 기술.
	- Type 1 (Bare-metal): 하드웨어 위에 직접 설치.
	- Type 2 (Hosted): 호스트 OS 위에서 동작 (VirtualBox가 여기에 해당).
* Host vs Guest: Hypervisor가 설치된 물리 장비 = Host / VM으로 실행되는 OS = Guest
* CentOS vs Debian:
	- CentOS: RHEL 기반, .rpm + yum, 기업 서버용.
	- Debian: .deb + dpkg/APT, 패키지 관리 편리, Ubuntu 기반.
* 장점: 비용 절감, 빠른 환경 구성, 다운타임 최소화.
* aptitude vs apt: aptitude는 CLI+GUI, apt는 CLI 전용으로 간편.
* AppArmor: 커널 보안 모듈, 프로그램 권한을 profile 기반으로 제어.

---

### (2) Simple Setup
* GUI 비활성화 상태에서 부팅.
* SSH, UFW 서비스 실행 확인.
* 사용자 비밀번호는 정책(길이 10자 이상, 대문자+숫자 포함, 반복 제한 등)을 충족해야 함.

---


### (3) User Management
* 사용자 계정은 sudo, user42 그룹에 속해야 함.
* 새 사용자 추가 및 password policy 설정 가능해야 함.
* evaluating 그룹을 만들고 사용자 추가.
* Policy 장단점: 보안 강화 vs 사용자가 비밀번호를 기억하기 어려움.

---


### (4) Hostname & Partitions
* Hostname 변경 및 복원 가능해야 함.
* lsblk를 통한 파티션 구조 확인.
* LVM (Logical Volume Manager): 물리 디스크를 논리적으로 묶어 유연한 관리 가능.
	- PV(Physical Volume) → VG(Volume Group) → LV(Logical Volume) 구조.

---

### (5) SUDO
* sudo 설치 여부 확인 (sudo --version).
* usermod -aG sudo <user>로 사용자 권한 부여.
* /etc/sudoers에서 secure_path, 로그 기록, 시도 횟수 제한 설정.
* 장점: root 비밀번호 공유 불필요, log 추적 가능, 보안 강화.

---


### (6) UFW
* Uncomplicated Firewall: iptables를 단순화한 방화벽 관리 툴.
* 상태 확인: sudo ufw status
* 포트 제어: sudo ufw allow 4242, 필요 시 추가/삭제 가능.
* 사용 이유: 불필요한 네트워크 접근 차단, 보안 강화.

---


### (7) SSH
* 원격 접속용 보안 프로토콜.
* 모든 데이터는 암호화, Public/Private Key 기반 동작.
* 포트는 4242만 허용, root 로그인 차단 필수.
* 접속 예시: ssh user@ip -p 4242

---


### (8) Script Monitoring
* 스크립트는 시스템 자원과 상태를 10분마다 출력해야 함.
* 출력 항목: Architecture, CPU, Memory, Disk, 부하율, LVM, TCP 연결 수, User 수, Network 정보, sudo 실행 횟수 등.
* cron을 통해 주기적 실행 (*/10 * * * *).
* 필요 시 1분 간격으로 변경 가능 (*/1).


---

## 5️⃣ 배운 점
	•	운영체제 설치 및 리눅스 기본 아키텍처 이해 (부팅, 파일시스템, 패키지 관리)
	•	사용자 계정 관리와 권한 제어의 중요성
	•	PAM, UFW, sudo 설정을 통해 보안 규칙을 구체적으로 적용하는 방법
	•	서비스 설치 시 의존성 문제 해결, 설정 파일(.conf) 수정 과정에서 문제 해결 능력 강화
	•	cron job, bash 스크립트를 통한 운영 자동화 경험
	•	실제 서버 운영 환경에서 발생할 수 있는 보안/운영 이슈를 실습 기반으로 체득

---

## 6️⃣ 주요 명령어

### 🖥️ 시스템 정보 & 모니터링
	•	uname -a → 커널/시스템 정보 확인
	•	hostnamectl → 호스트네임, OS 버전, 커널 버전 확인
	•	lsblk → 디스크/파티션/LVM 구조 확인
	•	df -h → 디스크 사용량 확인
	•	free -m → 메모리 사용량 확인
	•	uptime → 부팅 이후 경과 시간, 로드 평균 확인
	•	who -b → 마지막 부팅 시간 확인
	•	ps -ef / top / htop → 실행 중인 프로세스 확인

### 👤 사용자/권한 관리
	•	adduser <username> → 새 사용자 생성
	•	usermod -aG <group> <user> → 사용자 그룹 추가
	•	groups <user> → 해당 사용자가 속한 그룹 확인
	•	passwd <user> → 사용자 비밀번호 설정/변경
	•	sudo visudo → sudoers 파일 수정 (권한 제어)
	•	chmod / chown → 파일 권한 및 소유권 관리
	•	ls -l → 파일 권한 확인

### 🔒 보안 관련
	•	ufw enable / ufw status → 방화벽(UFW) 설정 및 상태 확인
	•	ss -tuln / netstat -tuln → 열려있는 포트 확인
	•	fail2ban-client status → Fail2ban 상태 확인 (SSH brute-force 방지)
	•	systemctl status ssh → SSH 서비스 상태 확인
	•	cat /etc/ssh/sshd_config → SSH 설정 확인 (ex: Port, PermitRootLogin)

### 💾 서비스/패키지 관리
	•	apt update && apt upgrade → 패키지 업데이트
	•	apt install <pkg> / apt remove <pkg> → 패키지 설치/삭제
	•	systemctl start|stop|restart <service> → 서비스 시작/중지/재시작
	•	systemctl enable <service> → 부팅 시 자동 시작 등록

### 📝 로그 확인
	•	journalctl -xe → 시스템 로그 확인
	•	tail -f /var/log/auth.log → 인증 로그 확인 (sudo/ssh)
	•	cat /var/log/sudo.log → sudo 실행 로그 확인
	•	last / lastlog → 사용자 로그인 기록 확인

### 📦 LVM 관리
	•	pvdisplay → Physical Volume 확인
	•	vgdisplay → Volume Group 확인
	•	lvdisplay → Logical Volume 확인
	•	mount → 마운트된 파티션 확인

### 🛠️ 스크립트 관련 (Monitoring.sh 같은 과제)
	•	crontab -e → 크론 작업 등록
	•	bash monitoring.sh → 스크립트 실행
	•	chmod +x monitoring.sh → 실행 권한 부여
 	•	cat /var/log/monitoring.log → 시스템 모니터링 로그 확인

### 🌐 WordPress 접근
웹 브라우저에서:
```
http://<server_ip>/wordpress
```

## 7️⃣ 기술 스택
	•	운영체제: Debian (VirtualBox 환경)
	•	서비스: SSH, UFW, cron, sudo, WordPress, MariaDB, vsftpd
	•	보안: PAM 모듈, 비밀번호 정책, 방화벽 설정
	•	스크립트: Bash (monitoring.sh)
