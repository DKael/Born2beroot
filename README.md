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

## 4️⃣ 배운 점
	•	운영체제 설치 및 리눅스 기본 아키텍처 이해 (부팅, 파일시스템, 패키지 관리)
	•	사용자 계정 관리와 권한 제어의 중요성
	•	PAM, UFW, sudo 설정을 통해 보안 규칙을 구체적으로 적용하는 방법
	•	서비스 설치 시 의존성 문제 해결, 설정 파일(.conf) 수정 과정에서 문제 해결 능력 강화
	•	cron job, bash 스크립트를 통한 운영 자동화 경험
	•	실제 서버 운영 환경에서 발생할 수 있는 보안/운영 이슈를 실습 기반으로 체득

---

## 5️⃣ 사용 방법

### 📦 VirtualBox VM 실행
bash
```
# VM 실행
VBoxManage startvm "Born2beroot"
```

### 🔑 SSH 접속
bash
```
ssh <username>@<server_ip> -p <custom_port>
```

### 🧾 시스템 모니터링 로그 확인
bash
```
cat /var/log/monitoring.log
```

### 🌐 WordPress 접근
웹 브라우저에서:
```
http://<server_ip>/wordpress
```

## 6️⃣ 기술 스택
	•	운영체제: Debian (VirtualBox 환경)
	•	서비스: SSH, UFW, cron, sudo, WordPress, MariaDB, vsftpd
	•	보안: PAM 모듈, 비밀번호 정책, 방화벽 설정
	•	스크립트: Bash (monitoring.sh)
