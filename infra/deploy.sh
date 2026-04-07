#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log()  { echo -e "${GREEN}[DEPLOY]${NC} $*"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $*"; }
err()  { echo -e "${RED}[ERROR]${NC} $*" >&2; }

if [ ! -f env/bot.env ] || [ ! -f env/db.env ]; then
  err "env/bot.env 또는 env/db.env 파일이 없습니다."
  err "cp env/bot.env.example env/bot.env && cp env/db.env.example env/db.env 로 생성 후 값을 채워주세요."
  exit 1
fi


log "Submodule 업데이트 중..."
cd "$SCRIPT_DIR/.."
git submodule update --init --recursive
cd "$SCRIPT_DIR"

ACTION="${1:-up}"

case "$ACTION" in
  up)
    log "서비스 시작 (빌드 포함)..."
    docker compose up -d --build
    log "서비스 상태:"
    docker compose ps
    ;;
  down)
    log "서비스 중지..."
    docker compose down
    ;;
  restart)
    log "서비스 재시작..."
    docker compose down
    docker compose up -d --build
    docker compose ps
    ;;
  logs)
    docker compose logs -f "${2:-}"
    ;;
  status)
    docker compose ps
    ;;
  pull)
    log "최신 코드 가져오는 중..."
    cd "$SCRIPT_DIR/.."
    git pull
    git submodule update --init --recursive
    cd "$SCRIPT_DIR"
    log "서비스 재빌드 및 재시작..."
    docker compose up -d --build
    docker compose ps
    ;;
  *)
    echo "Usage: $0 {up|down|restart|logs|status|pull}"
    echo ""
    echo "  up       - 서비스 시작 (빌드 포함)"
    echo "  down     - 서비스 중지"
    echo "  restart  - 서비스 재시작"
    echo "  logs     - 로그 확인 (logs bot / logs mariadb)"
    echo "  status   - 서비스 상태 확인"
    echo "  pull     - 최신 코드 pull 후 재배포"
    exit 1
    ;;
esac
